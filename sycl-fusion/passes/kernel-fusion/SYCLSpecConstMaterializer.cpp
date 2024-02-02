//==-------------------- SYCLSpecConstMaterializer.cpp ---------------------==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "SYCLSpecConstMaterializer.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/IRBuilder.h"

#define DEBUG_TYPE "sycl-spec-const-materializer"

using namespace llvm;

cl::opt<size_t> UseTestConstValues(
    "sycl-materializer-debug-value-size",
    cl::desc("Size of the spec const blob, debug use only."));

const bool SYCLSpecConstMaterializer::IsDebug =
    getenv("SYCL_MATERIALIZER_DEBUG");

// When run through the JIT pipeline we have no way of using this pass' debug
// type, hence the introduction of the environment variable above and the macro
// below.
#define MATERIALIZER_DEBUG(X)                                                  \
  do {                                                                         \
    if (IsDebug)                                                               \
      X;                                                                       \
    else                                                                       \
      LLVM_DEBUG(X);                                                           \
  } while (false)

static Constant *getScalarConstant(const unsigned char **ValPtr, Type *Ty) {
  if (Ty->isIntegerTy()) {
    unsigned NumBytes = Ty->getIntegerBitWidth() / 8;
    uint64_t IntValue = 0;
    std::memcpy(&IntValue, *ValPtr, NumBytes);
    *ValPtr = *ValPtr + NumBytes;
    return ConstantInt::get(Ty, IntValue);
  }
  if (Ty->isDoubleTy()) {
    double DoubleValue = *(reinterpret_cast<const double *>(*ValPtr));
    *ValPtr = *ValPtr + sizeof(double);
    return ConstantFP::get(Ty, DoubleValue);
  }
  if (Ty->isFloatTy()) {
    double DoubleValue = *(reinterpret_cast<const float *>(*ValPtr));
    *ValPtr = *ValPtr + sizeof(float);
    return ConstantFP::get(Ty, DoubleValue);
  }

  llvm_unreachable("Scalar type not found.");
}

static Constant *getConstantOfType(const unsigned char **ValPtr, Type *Ty) {
  assert(ValPtr && Ty && "Invalid input.");
  if (Ty->isIntegerTy() || Ty->isFloatTy() || Ty->isDoubleTy())
    return getScalarConstant(ValPtr, Ty);
  if (auto *ArrTy = dyn_cast<ArrayType>(Ty)) {
    SmallVector<Constant *> Elems;
    auto *ElemTy = ArrTy->getArrayElementType();
    auto NumElems = ArrTy->getArrayNumElements();
    for (uint64_t I = 0; I < NumElems; ++I)
      Elems.push_back(getConstantOfType(ValPtr, ElemTy));
    return ConstantArray::get(ArrayType::get(ElemTy, NumElems), Elems);
  }
  if (auto *StructTy = dyn_cast<StructType>(Ty)) {
    SmallVector<Constant *> StructElems;
    for (auto *ElemTy : StructTy->elements())
      StructElems.push_back(getConstantOfType(ValPtr, ElemTy));
    return ConstantStruct::get(StructTy, StructElems);
  }

  llvm_unreachable("Unknown type in getConstantOfType.");
}

SYCLSpecConstMaterializer::SYCLSpecConstMaterializer() {
  if (!UseTestConstValues)
    llvm_unreachable("Only allowed in debug test values.");
  static std::vector<unsigned char> DebugValues;
  SpecConstDataSize = UseTestConstValues.getValue();
  for (unsigned i = 0; i < SpecConstDataSize; ++i)
    DebugValues.push_back(static_cast<unsigned char>(i));
  SpecConstData = DebugValues.data();
  SpecConstDataSize = DebugValues.size();
}

void SYCLSpecConstMaterializer::allocateSpecConstant(StringRef KernelName) {
  for (auto I : llvm::enumerate(TypesAndOffsets)) {
    auto *const Ty = I.value().first;
    assert(Ty->isSized());
    const auto Offset = I.value().second;
    assert(Offset < SpecConstDataSize && "Out of bounds access.");
    const unsigned char *ValPtr = &SpecConstData[Offset];
    auto *Initializer = getConstantOfType(&ValPtr, I.value().first);
    // AMD's CONSTANT_ADDRESS and Nvidia's ADDRESS_SPACE_CONST happen to have
    // the same value.
    const unsigned AS = 4;
    std::string Name{"SpecConsBlob_" + std::string(KernelName) + "_" +
                     std::to_string(I.index())};
    auto *SpecConstGlobal = new GlobalVariable(
        *Mod, Ty, /*isConstant=*/true, GlobalValue::WeakODRLinkage, Initializer,
        Name, nullptr, GlobalValue::NotThreadLocal, AS,
        /*isExternallyInitialized=*/false);
    SpecConstGlobal->setAlignment(Align(4));
    TypesAndOffsetsToBlob[I.value()] = SpecConstGlobal;
  }
}

void SYCLSpecConstMaterializer::fixupSpecConstantUses() {
  IRBuilder B(Mod->getContext());
  for (auto &LT : LoadsToTypes) {
    auto *Load = LT.first;
    auto &TyOff = LT.second;
    auto *GV = TypesAndOffsetsToBlob[TyOff];
    B.SetInsertPoint(Load);
    auto *NewLoad = B.CreateLoad(TyOff.first, GV);
    Load->replaceAllUsesWith(NewLoad);
    ToErase.push_back(Load);
  }
}

SmallVector<LoadInst *>
SYCLSpecConstMaterializer::collectGEPsLoads(GetElementPtrInst *GEP) {
  SmallVector<LoadInst *> Loads;
  SmallVector<Instruction *> WorkList;
  WorkList.push_back(GEP);
  while (!WorkList.empty()) {
    Instruction *I = WorkList.pop_back_val();
    ToErase.push_back(I);
    for (auto *U : I->users()) {
      auto *NewI = cast<Instruction>(&*U);
      switch (NewI->getOpcode()) {
      default: {
        std::string Str;
        raw_string_ostream Out(Str);
        Out << "Unhandled instruction: ";
        NewI->print(Out);
        llvm_unreachable(Str.c_str());
      }
      case Instruction::BitCast: {
        WorkList.push_back(NewI);
        break;
      }
      case Instruction::Load: {
        Loads.push_back(cast<LoadInst>(NewI));
        break;
      }
      }
    }
  }

  return Loads;
}

void SYCLSpecConstMaterializer::populateUses(Argument *A) {
  SmallVector<AddrSpaceCastInst *> ASCasts;
  for (auto *U : A->users()) {
    auto *I = cast<Instruction>(&*U);
    switch (I->getOpcode()) {
    default: {
      std::string Str;
      raw_string_ostream Out(Str);
      Out << "Unhandled instruction: ";
      I->print(Out);
      llvm_unreachable(Str.c_str());
    }
    case Instruction::AddrSpaceCast: {
      ASCasts.push_back(cast<AddrSpaceCastInst>(I));
      ToErase.push_back(I);
      break;
    }
    }
  }

  const DataLayout &DL = A->getParent()->getParent()->getDataLayout();
  for (auto *AS : ASCasts) {
    for (auto *U : AS->users()) {
      auto *I = cast<Instruction>(&*U);
      switch (I->getOpcode()) {
      default: {
        std::string Str;
        raw_string_ostream Out(Str);
        Out << "Unhandled instruction: ";
        I->print(Out);
        llvm_unreachable(Str.c_str());
      }
      case Instruction::GetElementPtr: {
        auto *GEP = cast<GetElementPtrInst>(I);
        unsigned int ASL = GEP->getPointerAddressSpace();
        unsigned OffsetBitWidth = DL.getIndexSizeInBits(ASL);
        APInt Offset(OffsetBitWidth, 0);
        bool FoundOffset = GEP->accumulateConstantOffset(DL, Offset);
        if (!FoundOffset)
          llvm_unreachable_internal("Offset unknown.");
        auto Loads = collectGEPsLoads(GEP);
        for (auto *Load : Loads) {
          TypeAtOffset TyO{Load->getType(), Offset.getSExtValue()};
          TypesAndOffsets.insert(TyO);
          LoadsToTypes[Load] = TyO;
        }
        break;
      }
      }
    }
  }
}

void SYCLSpecConstMaterializer::reportAndReset() {
  if (LoadsToTypes.empty()) {
    MATERIALIZER_DEBUG(dbgs()
                       << "Did not find any loads from spec const buffer.\n");
  } else {
    MATERIALIZER_DEBUG(dbgs() << "Replaced: " << LoadsToTypes.size()
                              << " loads from spec const buffer.\n");
    MATERIALIZER_DEBUG(dbgs() << "Load to global variable mappings:\n");
    for (auto &LTT : LoadsToTypes) {
      MATERIALIZER_DEBUG(dbgs() << "\tLoad:\n");
      MATERIALIZER_DEBUG(LTT.first->dump());
      MATERIALIZER_DEBUG(dbgs() << "\tGlobal Variable:\n");
      MATERIALIZER_DEBUG(TypesAndOffsetsToBlob[LTT.second]->dump());
      MATERIALIZER_DEBUG(dbgs() << "\n");
    }
  }
  MATERIALIZER_DEBUG(dbgs() << "\n\n");

  // Erase in revers order to not invalidate use-def chains.
  for (auto *I : llvm::reverse(ToErase))
    I->eraseFromParent();

  // Reset the state.
  TypesAndOffsets.clear();
  TypesAndOffsetsToBlob.clear();
  LoadsToTypes.clear();
  ToErase.clear();
}

PreservedAnalyses
SYCLSpecConstMaterializer::handleKernel(llvm::Function &Kernel) {
  auto *SpecConstArg = std::prev(Kernel.arg_end());
  if (SpecConstArg->getName() != "_arg__specialization_constants_buffer")
    return PreservedAnalyses::all();

  populateUses(SpecConstArg);

  allocateSpecConstant(Kernel.getName());

  fixupSpecConstantUses();

  reportAndReset();

  return PreservedAnalyses::none();
}

PreservedAnalyses SYCLSpecConstMaterializer::run(Function &F,
                                                 FunctionAnalysisManager &AM) {
  Mod = F.getParent();
  MATERIALIZER_DEBUG(dbgs() << "Working on kernel:\n==================\n"
                            << F.getName() << "\n\n");

  AT = TargetHelpers::getArchType(*Mod);

  // Invariant: This pass is only intended to operate on SYCL kernels being
  // compiled to either `nvptx{,64}-nvidia-cuda`, or `amdgcn-amd-amdhsa`
  // triples.
  if (TargetHelpers::ArchType::Unsupported == AT)
    return PreservedAnalyses::all();

  return handleKernel(F);
}
