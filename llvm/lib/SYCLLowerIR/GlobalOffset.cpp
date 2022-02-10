//===--------- GlobalOffset.cpp - Global Offset Support for CUDA --------- ===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// TODO: JKB:
// This pass operates on SYCL kernels being compiled to CUDA. It looks for uses
// of the `llvm.nvvm.implicit.offset` intrinsic and replaces it with a offset
// parameter which will be threaded through from the kernel entry point.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsAMDGPU.h"
#include "llvm/IR/IntrinsicsNVPTX.h"
#include "llvm/IR/PassManager.h"
#include "llvm/SYCLLowerIR/SYCLLowerIRTargetHelpers.h"
#include "llvm/Target/TargetIntrinsicInfo.h"
#include "llvm/Transforms/Utils/Cloning.h"

using namespace llvm;
using namespace SYCLLowerIRTargetHelpers;

#define DEBUG_TYPE "globaloffset"

namespace llvm {
ModulePass *createGlobalOffsetPass();
void initializeGlobalOffsetPass(PassRegistry &);
} // end namespace llvm

namespace {

class GlobalOffset : public ModulePass {
public:
  static char ID;
  GlobalOffset() : ModulePass(ID) {}

  bool runOnModule(Module &M) override {
    if (skipModule(M))
      return false;

    M.dump();
    AT = getArchType(M);
    llvm::Function *ImplicitOffsetIntrinsic = M.getFunction(Intrinsic::getName(
        AT == ArchType::Cuda ? Intrinsic::nvvm_implicit_offset
                             : Intrinsic::amdgcn_implicit_offset));

    if (!ImplicitOffsetIntrinsic || ImplicitOffsetIntrinsic->use_empty()) {
      return false;
    }

    KernelImplicitArgumentType =
        ArrayType::get(Type::getInt32Ty(M.getContext()), 3);
    ImplicitOffsetPtrType = Type::getInt32Ty(M.getContext())->getPointerTo();
    assert(
        (!ImplicitOffsetIntrinsic ||
         ImplicitOffsetIntrinsic->getReturnType() == ImplicitOffsetPtrType) &&
        "Implicit offset intrinsic does not return the expected type");

    SmallVector<KernelPayload> KernelPayloads;
    populateKernels(M, KernelPayloads, AT);

    // Validate kernels and populate entry map
    EntryPointMetadata = validateKernels(M, KernelPayloads);

    // Add implicit parameters to all direct and indirect users of the offset
    addImplicitParameterToCallers(M, ImplicitOffsetIntrinsic, nullptr);

    // Assert that all uses of `ImplicitOffsetIntrinsic` are removed and delete
    // it.
    assert(ImplicitOffsetIntrinsic->use_empty() &&
           "Not all uses of intrinsic removed");
    ImplicitOffsetIntrinsic->eraseFromParent();

    return true;
  }

  void processKernelEntryPoint(Module &M, Function *Func) {
    assert(EntryPointMetadata.count(Func) != 0 &&
           "Function must be an entry point");

    LLVMContext &Ctx = M.getContext();
    MDNode *FuncMetadata = EntryPointMetadata[Func];

    bool AlreadyProcessed = ProcessedFunctions.count(Func) == 1;
    if (AlreadyProcessed)
      return;

    // Add the new argument to all other kernel entry points, despite not
    // using the global offset.
    auto *KernelMetadata = M.getNamedMetadata(getAnnotationString(AT).c_str());
    assert(KernelMetadata && "IR compiled must have correct annotations");

    auto *NewFunc = addOffsetArgumentToFunction(
                        M, Func, KernelImplicitArgumentType->getPointerTo(),
                        /*KeepOriginal=*/true)
                        .first;
    Argument *NewArgument = NewFunc->arg_begin() + (NewFunc->arg_size() - 1);
    // Pass the values by value to the kernel
    NewArgument->addAttr(
        Attribute::getWithByValType(Ctx, KernelImplicitArgumentType));

    // Add the metadata.
    Metadata *NewMetadata[] = {ConstantAsMetadata::get(NewFunc),
                               FuncMetadata->getOperand(1),
                               FuncMetadata->getOperand(2)};
    KernelMetadata->addOperand(MDNode::get(Ctx, NewMetadata));

    // Create alloca of zeros for the implicit offset in original func
    BasicBlock *EntryBlock = &Func->getEntryBlock();
    IRBuilder<> Builder(EntryBlock, EntryBlock->getFirstInsertionPt());
    Type *ImplicitOffsetType =
        ArrayType::get(Type::getInt32Ty(M.getContext()), 3);
    AllocaInst *ImplicitOffset = Builder.CreateAlloca(ImplicitOffsetType);
    uint64_t AllocByteSize =
        ImplicitOffset->getAllocationSizeInBits(M.getDataLayout()).getValue() /
        8;
    CallInst *MemsetCall =
        Builder.CreateMemSet(ImplicitOffset, Builder.getInt8(0), AllocByteSize,
                             ImplicitOffset->getAlign());
    MemsetCall->addParamAttr(0, Attribute::NonNull);
    MemsetCall->addDereferenceableParamAttr(0, AllocByteSize);
    ProcessedFunctions[Func] = Builder.CreateConstInBoundsGEP2_32(
        ImplicitOffsetType, ImplicitOffset, 0, 0);
  }

  // This function adds an implicit parameter to the function containing a call
  // instruction to the implicit offset intrinsic or another function (which
  // eventually calls the instrinsic). If the call instruction is to the
  // implicit offset intrinsic, then the intrinisic is replaced with the
  // parameter that was added.
  //
  // `Callee` is the function (to which this transformation has already been
  // applied), or to the implicit offset intrinsic. `CalleeWithImplicitParam`
  // indicates whether Callee is to the implicit intrinsic (when `nullptr`) or
  // to another function (not `nullptr`) - this is used to know whether calls to
  // it needs to have the implicit parameter added to it or replaced with the
  // implicit parameter.
  //
  // Once the function, say `F`, containing a call to `Callee` has the implicit
  // parameter added, callers of `F` are processed by recursively calling this
  // function, passing `F` to `CalleeWithImplicitParam`.
  //
  // Since the cloning of entry points may alter the users of a function, the
  // cloning must be done as early as possible, as to ensure that no users are
  // added to previous callees in the call-tree.
  void addImplicitParameterToCallers(Module &M, Value *Callee,
                                     Function *CalleeWithImplicitParam) {

    // Make sure that all entry point callers are processed.
    SmallVector<User *, 8> Users{Callee->users()};
    for (User *U : Users) {
      auto *Call = dyn_cast<CallInst>(U);
      if (!Call)
        continue;

      Function *Caller = Call->getFunction();
      if (EntryPointMetadata.count(Caller) != 0) {
        processKernelEntryPoint(M, Caller);
      }
    }

    // User collection may have changed, so we reinitialize it.
    Users = SmallVector<User *, 8>{Callee->users()};
    for (User *U : Users) {
      auto *CallToOld = dyn_cast<CallInst>(U);
      if (!CallToOld)
        return;

      auto *Caller = CallToOld->getFunction();

      // Determine if `Caller` needs processed or if this is another callsite
      // from an already-processed function.
      Function *NewFunc;
      Value *ImplicitOffset = ProcessedFunctions[Caller];
      bool AlreadyProcessed = ImplicitOffset != nullptr;
      if (AlreadyProcessed) {
        NewFunc = Caller;
      } else {
        std::tie(NewFunc, ImplicitOffset) =
            addOffsetArgumentToFunction(M, Caller);
      }

      if (!CalleeWithImplicitParam) {
        // Replace intrinsic call with parameter.
        printf("------> 1\n");
        printf("CallToOld:\n");
        CallToOld->dump();
        printf("ImplicitOffset:\n");
        ImplicitOffset->dump();
        printf("------\n");
        CallToOld->replaceAllUsesWith(ImplicitOffset);
      } else {
        // Build up a list of arguments to call the modified function using.
        llvm::SmallVector<Value *, 8> ImplicitOffsets;
        for (Use &U : CallToOld->args()) {
          ImplicitOffsets.push_back(U);
        }
        ImplicitOffsets.push_back(ImplicitOffset);

        // Replace call to other function (which now has a new parameter),
        // with a call including the new parameter to that same function.
        auto *NewCaller = CallInst::Create(
            /* Ty= */ CalleeWithImplicitParam->getFunctionType(),
            /* Func= */ CalleeWithImplicitParam,
            /* Args= */ ImplicitOffsets,
            /* NameStr= */ Twine(),
            /* InsertBefore= */ CallToOld);
        NewCaller->setTailCallKind(CallToOld->getTailCallKind());
        NewCaller->copyMetadata(*CallToOld);
        printf("------> 2\n");
        printf("CallToOld:\n");
        CallToOld->dump();
        printf("NewCaller:\n");
        NewCaller->dump();
        printf("------\n");
        CallToOld->replaceAllUsesWith(NewCaller);

        if (CallToOld->hasName()) {
          NewCaller->takeName(CallToOld);
        }
      }

      // Remove the caller now that it has been replaced.
      CallToOld->eraseFromParent();

      if (!AlreadyProcessed) {
        // Process callers of the old function.
        addImplicitParameterToCallers(M, Caller, NewFunc);

        // Now that the old function is dead, delete it.
        Caller->dropAllReferences();
        Caller->eraseFromParent();
      }
    }
  }

  std::pair<Function *, Value *>
  addOffsetArgumentToFunction(Module &M, Function *Func,
                              Type *ImplicitArgumentType = nullptr,
                              bool KeepOriginal = false) {
    FunctionType *FuncTy = Func->getFunctionType();
    const AttributeList &FuncAttrs = Func->getAttributes();
    ImplicitArgumentType =
        ImplicitArgumentType ? ImplicitArgumentType : ImplicitOffsetPtrType;

    // Construct an argument list containing all of the previous arguments.
    SmallVector<Type *, 8> Arguments;
    SmallVector<AttributeSet, 8> ArgumentAttributes;

    unsigned i = 0;
    for (Function::arg_iterator FuncArg = Func->arg_begin(),
                                FuncEnd = Func->arg_end();
         FuncArg != FuncEnd; ++FuncArg, ++i) {
      Arguments.push_back(FuncArg->getType());
      ArgumentAttributes.push_back(FuncAttrs.getParamAttrs(i));
    }

    // Add the offset argument. Must be the same type as returned by
    // `llvm.{amdgcn|nvvm}.implicit.offset`.

    Arguments.push_back(ImplicitArgumentType);
    ArgumentAttributes.push_back(AttributeSet());

    // Build the new function.
    AttributeList NAttrs =
        AttributeList::get(Func->getContext(), FuncAttrs.getFnAttrs(),
                           FuncAttrs.getRetAttrs(), ArgumentAttributes);
    assert(!FuncTy->isVarArg() && "Variadic arguments prohibited in SYCL");
    FunctionType *NewFuncTy = FunctionType::get(FuncTy->getReturnType(),
                                                Arguments, FuncTy->isVarArg());

    Function *NewFunc = Function::Create(NewFuncTy, Func->getLinkage(),
                                         Func->getAddressSpace());

    // Keep original function ordering.
    M.getFunctionList().insertAfter(Func->getIterator(), NewFunc);

    if (KeepOriginal) {
      // TODO: Are there better naming alternatives that allow for unmangling?
      NewFunc->setName(Func->getName() + "_with_offset");

      ValueToValueMapTy VMap;
      for (Function::arg_iterator FuncArg = Func->arg_begin(),
                                  FuncEnd = Func->arg_end(),
                                  NewFuncArg = NewFunc->arg_begin();
           FuncArg != FuncEnd; ++FuncArg, ++NewFuncArg) {
        VMap[FuncArg] = NewFuncArg;
      }

      SmallVector<ReturnInst *, 8> Returns;
      CloneFunctionInto(NewFunc, Func, VMap,
                        CloneFunctionChangeType::GlobalChanges, Returns);
    } else {
      NewFunc->copyAttributesFrom(Func);
      NewFunc->setComdat(Func->getComdat());
      NewFunc->setAttributes(NAttrs);
      NewFunc->takeName(Func);

      // Splice the body of the old function right into the new function.
      NewFunc->getBasicBlockList().splice(NewFunc->begin(),
                                          Func->getBasicBlockList());

      for (Function::arg_iterator FuncArg = Func->arg_begin(),
                                  FuncEnd = Func->arg_end(),
                                  NewFuncArg = NewFunc->arg_begin();
           FuncArg != FuncEnd; ++FuncArg, ++NewFuncArg) {
        printf("------> 3\n");
        printf("FuncArg:\n");
        FuncArg->dump();
        printf("NewFuncArg:\n");
        NewFuncArg->dump();
        printf("------\n");
        FuncArg->replaceAllUsesWith(NewFuncArg);
      }

      // Clone metadata of the old function, including debug info descriptor.
      SmallVector<std::pair<unsigned, MDNode *>, 1> MDs;
      Func->getAllMetadata(MDs);
      for (auto MD : MDs)
        NewFunc->addMetadata(MD.first, *MD.second);
    }

    Value *ImplicitOffset = NewFunc->arg_begin() + (NewFunc->arg_size() - 1);
    // Add bitcast to match the return type of the intrinsic if needed.
    if (ImplicitArgumentType != ImplicitOffsetPtrType) {
      BasicBlock *EntryBlock = &NewFunc->getEntryBlock();
      IRBuilder<> Builder(EntryBlock, EntryBlock->getFirstInsertionPt());
      ImplicitOffset =
          Builder.CreateBitCast(ImplicitOffset, ImplicitOffsetPtrType);
    }

    ProcessedFunctions[NewFunc] = ImplicitOffset;

    // Return the new function and the offset argument.
    return {NewFunc, ImplicitOffset};
  }

  static DenseMap<Function *, MDNode *>
  validateKernels(Module &M, SmallVector<KernelPayload> &KernelPayloads) {
    SmallPtrSet<GlobalValue *, 8u> Used;
    SmallVector<GlobalValue *, 4> Vec;
    collectUsedGlobalVariables(M, Vec, /*CompilerUsed=*/false);
    collectUsedGlobalVariables(M, Vec, /*CompilerUsed=*/true);
    Used = {Vec.begin(), Vec.end()};

    auto HasUseOtherThanLLVMUsed = [&Used](GlobalValue *GV) {
      if (GV->use_empty())
        return false;
      return !GV->hasOneUse() || !Used.count(GV);
    };

    llvm::DenseMap<Function *, MDNode *> EntryPointMetadata;
    for (auto &KP : KernelPayloads) {
      KP.Kernel->dump();
      KP.MD->dump();
      if (HasUseOtherThanLLVMUsed(KP.Kernel))
        llvm_unreachable("Kernel entry point can't have uses.");

      EntryPointMetadata[KP.Kernel] = KP.MD;
    }

    return EntryPointMetadata;
  }

  virtual llvm::StringRef getPassName() const override {
    return "Add implicit SYCL global offset";
  }

private:
  // Keep track of which functions have been processed to avoid processing twice
  llvm::DenseMap<Function *, Value *> ProcessedFunctions;
  // Keep a map of all entry point functions with metadata
  llvm::DenseMap<Function *, MDNode *> EntryPointMetadata;
  llvm::Type *KernelImplicitArgumentType;
  llvm::Type *ImplicitOffsetPtrType;

  SYCLLowerIRTargetHelpers::ArchType AT;
};

} // end anonymous namespace

char GlobalOffset::ID = 0;

INITIALIZE_PASS(GlobalOffset, "globaloffset", "SYCL Global Offset", false,
                false)

ModulePass *llvm::createGlobalOffsetPass() { return new GlobalOffset(); }
