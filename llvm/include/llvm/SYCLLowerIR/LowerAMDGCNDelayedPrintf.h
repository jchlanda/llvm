//===----- LowerAMDGCNDelayedPrintf.h - LowerAMDGCNDelayedPrintf Pass -----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// TODO: JKB:
//
//===----------------------------------------------------------------------===//
//
#ifndef LLVM_LOWER_AMDGCN_DELAYED_PRINTF
#define LLVM_LOWER_AMDGCN_DELAYED_PRINTF

#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"

namespace llvm {

class LowerAMDGCNDelayedPrintf
    : public PassInfoMixin<LowerAMDGCNDelayedPrintf> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &);

private:
  void gatherCalls(Module &M);
  void gatherCalls2(Module &M);
  void processPrintfCall(CallInst *CI);
  bool isSROANeeded() const;

private:
  SmallVector<CallInst *, 4> WorkList;
  Function *PrintfIntrinsic;
};
} // namespace llvm

#endif // LLVM_LOWER_AMDGCN_DELAYED_PRINTF
