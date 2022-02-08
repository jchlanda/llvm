//===----- SYCLLowerIRTargetHelpers.cpp - Helpers for SYCL kernels ------- ===//
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

#include "llvm/ADT/StringSwitch.h"
#include "llvm/SYCLLowerIR/SYCLLowerIRTargetHelpers.h"

using namespace llvm;

namespace llvm {
namespace SYCLLowerIRTargetHelpers {

KernelPayload::KernelPayload(Function *Kernel, MDNode *MD)
    : Kernel(Kernel), MD(MD) {}

ArchType getArchType(const Module &M) {
  return StringSwitch<ArchType>(M.getTargetTriple().c_str())
      .Case("nvptx64-nvidia-cuda", ArchType::Cuda)
      .Case("nvptx-nvidia-cuda", ArchType::Cuda)
      .Case("amdgcn-amd-amdhsa", ArchType::AMDHSA)
      .Default(ArchType::Unsupported);
}

unsigned getArchSharedASValue(ArchType AT) {
  switch (AT) {
  case ArchType::Cuda:
    // ADDRESS_SPACE_SHARED = 3,
    return 3;
  case ArchType::AMDHSA:
    // LOCAL_ADDRESS = 3,
    return 3;
  default:
    llvm_unreachable("Unknown arch type.");
  }
}

void populateKernels(Module &M, SmallVector<KernelPayload> &Kernels,
                     ArchType AT) {
  std::string Annotation;
  switch (AT) {
  case SYCLLowerIRTargetHelpers::ArchType::Cuda:
    Annotation.assign("nvvm.annotations");
    break;
  case SYCLLowerIRTargetHelpers::ArchType::AMDHSA:
    Annotation.assign("amdgcn.annotations");
    break;
  default:
    llvm_unreachable("Unsupported arch type.");
  }
  //
  // Access `nvvm.annotations` to determine which functions are kernel entry
  // points.
  auto *NvvmMetadata = M.getNamedMetadata(Annotation);
  if (!NvvmMetadata)
    return;

  for (auto *MetadataNode : NvvmMetadata->operands()) {
    if (MetadataNode->getNumOperands() != 3)
      continue;

    // NVPTX identifies kernel entry points using metadata nodes of the form:
    //   !X = !{<function>, !"kernel", i32 1}
    const MDOperand &TypeOperand = MetadataNode->getOperand(1);
    auto *Type = dyn_cast<MDString>(TypeOperand);
    if (!Type)
      continue;
    // Only process kernel entry points.
    if (Type->getString() != "kernel")
      continue;

    // Get a pointer to the entry point function from the metadata.
    const MDOperand &FuncOperand = MetadataNode->getOperand(0);
    if (!FuncOperand)
      continue;
    auto *FuncConstant = dyn_cast<ConstantAsMetadata>(FuncOperand);
    if (!FuncConstant)
      continue;
    auto *Func = dyn_cast<Function>(FuncConstant->getValue());
    if (!Func)
      continue;

    Kernels.push_back(KernelPayload(Func, MetadataNode));
  }
}

} // namespace SYCLLowerIRTargetHelpers
} // namespace llvm
