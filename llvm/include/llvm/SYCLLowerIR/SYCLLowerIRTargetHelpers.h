//===------- SYCLLowerIRTargetHelpers.h - Helpers for SYCL kernels ------- ===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// TODO: JKB: Provide info.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SYCL_SYCL_LOWER_IR_TARGET_HELPERS_H
#define LLVM_SYCL_SYCL_LOWER_IR_TARGET_HELPERS_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"

using namespace llvm;

namespace llvm {
namespace SYCLLowerIRTargetHelpers {

enum class ArchType { Cuda, AMDHSA, Unsupported };

struct KernelPayload {
  KernelPayload(Function *Kernel, MDNode *MD = nullptr);
  Function *Kernel;
  MDNode *MD;
};

ArchType getArchType(const Module &M);
unsigned getArchSharedASValue(ArchType AT);

void populateKernels(Module &M, SmallVector<KernelPayload> &Kernels,
                     SYCLLowerIRTargetHelpers::ArchType AT);
} // end namespace SYCLLowerIRTargetHelpers
} // end namespace llvm

#endif
