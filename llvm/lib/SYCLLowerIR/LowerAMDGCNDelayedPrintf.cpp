//===--- LowerAMDGCNDelayedPrintf.cpp - LowerAMDGCNDelayedPrintf Pass -----===//
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

#include "llvm/SYCLLowerIR/LowerAMDGCNDelayedPrintf.h"

#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/IntrinsicsAMDGPU.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Transforms/IPO/AlwaysInliner.h"
#include "llvm/Transforms/Scalar/SROA.h"
#include "llvm/Transforms/Utils/AMDGPUEmitPrintf.h"

#define DEBUG_TYPE "LowerAMDGCNDelayedPrintf"

using namespace llvm;

static cl::opt<bool> PreventOptPipeline(
    "fsycl-no-amdgcn-fallback-printf-opt", cl::Hidden,
    cl::desc("Prevent the pass from running optimization pipeline in an "
             "attempt to understand format string."),
    cl::init(false));

bool LowerAMDGCNDelayedPrintf::isSROANeeded() const {
  if (WorkList.empty())
    return false;

  for (auto *CI : WorkList) {
    auto *Format = CI->getOperand(0);
    StringRef FormatString;
    if (!getConstantStringInfo(Format, FormatString))
      return true;
  }

  return false;
}

void LowerAMDGCNDelayedPrintf::processPrintfCall(CallInst *CI) {
  SmallVector<Value *> Args;
  for (auto &A : CI->args())
    Args.push_back(A);

  IRBuilder<> IRB(CI->getParent(), CI->getIterator());
  auto *LoweredPrintfCall =
      emitAMDGPUPrintfCall(IRB, Args, /* IsBuffered */ false);
  CI->replaceAllUsesWith(LoweredPrintfCall);
}

void LowerAMDGCNDelayedPrintf::gatherCalls(Module &M) {
  WorkList.clear();

  for (auto &F : M) {
    if (F.isDeclaration())
      continue;
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (auto *II = dyn_cast<IntrinsicInst>(&I)) {
          if (II->getIntrinsicID() ==
              Intrinsic::amdgcn_delayed_printf_emission) {
            assert(II->getNumOperands() >= 1 &&
                   "Malformed delayed printf call.");

            WorkList.push_back(II);
            // If not done already, set the delayed printf intrinsic, so it can
            // be removed from the module later on.
            if (!PrintfIntrinsic)
              PrintfIntrinsic = II->getCalledFunction();
          }
        }
      }
    }
  }
  LLVM_DEBUG(for (auto *WI : WorkList) WI->print(dbgs()););
}

PreservedAnalyses LowerAMDGCNDelayedPrintf::run(Module &M,
                                                ModuleAnalysisManager &MAM) {
  LLVM_DEBUG(dbgs() << "LowerAMDGCNDelayedPrintf module before:\n");
  LLVM_DEBUG(M.dump());

  gatherCalls(M);

  if (WorkList.empty())
    return PreservedAnalyses::all();

  if (isSROANeeded() && !PreventOptPipeline) {
    M.getContext().diagnose(DiagnosticInfoAMDGCNDelayedPrintf(
        "Failed to analyze format string, attempting SROA and Inlining. Use "
        "\"-fsycl-no-amdgcn-fallback-printf-opt\" to prevent fallback "
        "optimizations."));
    SmallPtrSet<Function *, 4> Parents;
    for (auto *WI : WorkList)
      Parents.insert(WI->getParent()->getParent());

    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    CGSCCAnalysisManager CGAM;
    PassBuilder PB;
    PB.registerModuleAnalyses(MAM);
    PB.registerCGSCCAnalyses(CGAM);
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);
    PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

    FunctionPassManager FPM;
    FPM.addPass(SROAPass{SROAOptions::ModifyCFG});
    for (auto *F : Parents) {
      if (F->hasFnAttribute(Attribute::AttrKind::NoInline)) {
        F->removeFnAttr(Attribute::AttrKind::NoInline);
        F->addFnAttr(Attribute::AttrKind::AlwaysInline);
      }
      FPM.run(*F, FAM);
    }

    ModulePassManager MPM;
    MPM.addPass(AlwaysInlinerPass{});
    MPM.run(M, MAM);
    gatherCalls(M);
    if (isSROANeeded())
      M.getContext().diagnose(DiagnosticInfoAMDGCNDelayedPrintf(
          "Unknown format string, printf in best effort mode only. Known "
          "limitations include inability to distinguish between %s and %p."));
  }

  for (auto *CI : WorkList)
    processPrintfCall(CI);
  for (auto *CI : reverse(WorkList))
    CI->eraseFromParent();
  WorkList.clear();

  assert(PrintfIntrinsic && "Expected intrinsic not set.");
  PrintfIntrinsic->eraseFromParent();

  LLVM_DEBUG(dbgs() << "LowerAMDGCNDelayedPrintf module after:\n");
  LLVM_DEBUG(M.dump());

  return PreservedAnalyses::none();
}
