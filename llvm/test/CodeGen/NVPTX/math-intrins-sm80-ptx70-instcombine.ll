; RUN: opt < %s -instcombine -S -mtriple=nvptx-nvidia-cuda -march=nvptx64 \
; RUN:    -mcpu=sm_80 -mattr=+ptx70 | \
; RUN: FileCheck %s

declare half @llvm.nvvm.fmin.f16(half, half)
declare half @llvm.nvvm.fmin.ftz.f16(half, half)
declare <2 x half> @llvm.nvvm.fmin.f16x2(<2 x half>, <2 x half>)
declare <2 x half> @llvm.nvvm.fmin.ftz.f16x2(<2 x half>, <2 x half>)

declare half @llvm.nvvm.fmax.f16(half, half)
declare half @llvm.nvvm.fmax.ftz.f16(half, half)
declare <2 x half> @llvm.nvvm.fmax.f16x2(<2 x half>, <2 x half>)
declare <2 x half> @llvm.nvvm.fmax.ftz.f16x2(<2 x half>, <2 x half>)

; CHECK-LABEL: fmin_f16
define half @fmin_f16(half %0, half %1) {
  ; CHECK-NOT: @llvm.nvvm.fmin.f16
  ; CHECK: @llvm.minnum.f16
  %res = call half @llvm.nvvm.fmin.f16(half %0, half %1)
  ret half %res
}

; CHECK-LABEL: fmin_ftz_f16
define half @fmin_ftz_f16(half %0, half %1) #0 {
  ; CHECK-NOT: @llvm.nvvm.fmin.ftz.f16
  ; CHECK: @llvm.minnum.f16
  %res = call half @llvm.nvvm.fmin.ftz.f16(half %0, half %1)
  ret half %res
}

; CHECK-LABEL: fmin_ftz_f16_no_attr
define half @fmin_ftz_f16_no_attr(half %0, half %1) {
  ; CHECK-NOT: @llvm.minnum.f16
  ; CHECK: @llvm.nvvm.fmin.ftz.f16
  %res = call half @llvm.nvvm.fmin.ftz.f16(half %0, half %1)
  ret half %res
}

; CHECK-LABEL: fmin_f16x2
define <2 x half> @fmin_f16x2(<2 x half> %0, <2 x half> %1) {
  ; CHECK-NOT: @llvm.nvvm.fmin.f16x2
  ; CHECK: @llvm.minnum.v2f16
  %res = call <2 x half> @llvm.nvvm.fmin.f16x2(<2 x half> %0, <2 x half> %1)
  ret <2 x half> %res
}

; CHECK-LABEL: fmin_ftz_f16x2
define <2 x half> @fmin_ftz_f16x2(<2 x half> %0, <2 x half> %1) #0 {
  ; CHECK-NOT: @llvm.nvvm.fmin.ftz.f16x2
  ; CHECK: @llvm.minnum.v2f16
  %res = call <2 x half> @llvm.nvvm.fmin.ftz.f16x2(<2 x half> %0, <2 x half> %1)
  ret <2 x half> %res
}

; CHECK-LABEL: fmin_ftz_f16x2_no_attr
define <2 x half> @fmin_ftz_f16x2_no_attr(<2 x half> %0, <2 x half> %1) {
  ; CHECK-NOT: @llvm.minnum.v2f16
  ; CHECK: @llvm.nvvm.fmin.ftz.f16x2
  %res = call <2 x half> @llvm.nvvm.fmin.ftz.f16x2(<2 x half> %0, <2 x half> %1)
  ret <2 x half> %res
}

; CHECK-LABEL: fmax_f16
define half @fmax_f16(half %0, half %1) {
  ; CHECK-NOT: @llvm.nvvm.fmax.f16
  ; CHECK: @llvm.maxnum.f16
  %res = call half @llvm.nvvm.fmax.f16(half %0, half %1)
  ret half %res
}

; CHECK-LABEL: fmax_ftz_f16
define half @fmax_ftz_f16(half %0, half %1) #0 {
  ; CHECK-NOT: @llvm.nvvm.fmax.ftz.f16
  ; CHECK: @llvm.maxnum.f16
  %res = call half @llvm.nvvm.fmax.ftz.f16(half %0, half %1)
  ret half %res
}

; CHECK-LABEL: fmax_ftz_f16_no_attr
define half @fmax_ftz_f16_no_attr(half %0, half %1) {
  ; CHECK-NOT: @llvm.maxnum.f16
  ; CHECK: @llvm.nvvm.fmax.ftz.f16
  %res = call half @llvm.nvvm.fmax.ftz.f16(half %0, half %1)
  ret half %res
}

; CHECK-LABEL: fmax_f16x2
define <2 x half> @fmax_f16x2(<2 x half> %0, <2 x half> %1) {
  ; CHECK-NOT: @llvm.nvvm.fmax.f16x2
  ; CHECK: @llvm.maxnum.v2f16
  %res = call <2 x half> @llvm.nvvm.fmax.f16x2(<2 x half> %0, <2 x half> %1)
  ret <2 x half> %res
}

; CHECK-LABEL: fmax_ftz_f16x2
define <2 x half> @fmax_ftz_f16x2(<2 x half> %0, <2 x half> %1) #0 {
  ; CHECK-NOT: @llvm.nvvm.fmax.ftz.f16x2
  ; CHECK: @llvm.maxnum.v2f16
  %res = call <2 x half> @llvm.nvvm.fmax.ftz.f16x2(<2 x half> %0, <2 x half> %1)
  ret <2 x half> %res
}

; CHECK-LABEL: fmax_ftz_f16x2_no_attr
define <2 x half> @fmax_ftz_f16x2_no_attr(<2 x half> %0, <2 x half> %1) {
  ; CHECK-NOT: @llvm.maxnum.v2f16
  ; CHECK: @llvm.nvvm.fmax.ftz.f16x2
  %res = call <2 x half> @llvm.nvvm.fmax.ftz.f16x2(<2 x half> %0, <2 x half> %1)
  ret <2 x half> %res
}

attributes #0 = { "denormal-fp-math"="preserve-sign" }
