//==--------------------- SYCLSpecConstMaterializer.h ----------------------==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SYCL_SPEC_CONST_MATERIALIZER_H
#define SYCL_SPEC_CONST_MATERIALIZER_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/SYCLLowerIR/TargetHelpers.h"
#include <map>
#include <set>

namespace llvm {
class Function;

///
/// Pass to materialize specialization constants. Specialization constants
/// represent constants whose values can be set dynamically during execution of
/// the SYCL application. The values of these constants are fixed when a SYCL
/// kernel function is invoked, and they do not change during the execution of
/// the kernel. This pass receives the values of all specialization constants
/// used by a kernel and materializes them as concrete types. Additionally, the
/// use of implicit specialization constant kernel argument is removed, in
/// favour of materialized values. This is done in order to be able to harness
/// the SCCP (Sparse Conditional Constant Propagation) to have all the constant
/// values propagated. Effectively, this pass enables function-level constant
/// propagation and merging of SYCL specialization constants.
class SYCLSpecConstMaterializer
    : public PassInfoMixin<SYCLSpecConstMaterializer> {
public:
  SYCLSpecConstMaterializer(unsigned char *SpecConstData,
                            size_t SpecConstDataSize)
      : SpecConstData(SpecConstData), SpecConstDataSize(SpecConstDataSize) {}

  SYCLSpecConstMaterializer();

  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);

private:
  // Main entry point, checks for implicit specialization constant kernel
  // argument and, if present, performs the optimizations.
  PreservedAnalyses handleKernel(Function &Kernel);

  // Collects all the uses of the specialization constant kernel argument.
  // This results with TypesAndOffsets and LoadsToType populated.
  void populateUses(Argument *A);

  // Use TypesAndOffsets to allocate global variables of given types which get
  // initialized with value taken from the specialization constant blob at a
  // given offset.
  void allocateSpecConstant(StringRef KernelName);

  // Re-write uses of, now defunct, loads from the specialization constant
  // kernel argument to the global variable.
  void fixupSpecConstantUses();

  // Walk down all uses of a given GEP instruction in order to find loads from
  // the offsetted pointer.
  SmallVector<LoadInst *> collectGEPsLoads(GetElementPtrInst *GEP);

  // Helper to report debug message (if enabled) and reset the state.
  void reportAndReset();

private:
  // Flag enabling debug output, guarded by: SYCL_MATERIALIZER_DEBUG environment
  // variable.
  static const bool IsDebug;

  // Run time known values of specialization constants passed from SYCL rt,
  // data pointer and size.
  unsigned char *SpecConstData;
  size_t SpecConstDataSize;

  // The pass is used for AMDGCN and NVIDIA, AT stores the current architecture.
  TargetHelpers::ArchType AT{TargetHelpers::ArchType::Unsupported};
  // Module the current function belongs to.
  Module *Mod{nullptr};

  // Type of the specialization constant and the offset into the SpecConstBlob,
  // at which the value is located.
  using TypeAtOffset = std::pair<Type *, uint64_t>;
  // Helper allowing sorting of TypeAtOffset containers.
  struct TypeAtOffsetCmp {
    bool operator()(const TypeAtOffset &LHS, const TypeAtOffset &RHS) const {
      if (std::get<0>(LHS) == std::get<0>(RHS))
        return std::get<1>(LHS) < std::get<1>(RHS);
      return std::get<0>(LHS) < std::get<0>(RHS);
    }
  };

  // Unique uses of spec const (type and offset).
  std::set<TypeAtOffset, TypeAtOffsetCmp> TypesAndOffsets{};
  // A map from type and offset to a specialization constant blob to a
  // GlobalVariable containing its value.
  std::map<TypeAtOffset, GlobalVariable *, TypeAtOffsetCmp>
      TypesAndOffsetsToBlob{};
  // A map of load instruction to its type and offset to a specialization
  // constant blob.
  std::map<LoadInst *, TypeAtOffset> LoadsToTypes{};

  // Instructions to be deleted from the kernel as a result of running the pass.
  SmallVector<Instruction *> ToErase{};
};
} // namespace llvm

#endif // SYCL_SPEC_CONST_MATERIALIZER_H
