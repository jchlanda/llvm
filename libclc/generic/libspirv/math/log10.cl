//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include "tables.h"
#include <clcmacro.h>

#ifdef cl_khr_fp64
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#endif // cl_khr_fp64

#define COMPILING_LOG10
#include "log_base.h"
#undef COMPILING_LOG10

_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, float, __spirv_ocl_log10, float);

#ifdef cl_khr_fp64
_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, double, __spirv_ocl_log10, double);
#endif // cl_khr_fp64

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_DEFINE_UNARY_BUILTIN(half, __spirv_ocl_log10, __builtin_log10, half)

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_log10(__clc_float16_t args_0) {
  return __spirv_ocl_log10(as_half(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_log10(__clc_vec2_float16_t args_0) {
  return __spirv_ocl_log10(as_half2(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_log10(__clc_vec3_float16_t args_0) {
  return __spirv_ocl_log10(as_half3(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_log10(__clc_vec4_float16_t args_0) {
  return __spirv_ocl_log10(as_half4(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_log10(__clc_vec8_float16_t args_0) {
  return __spirv_ocl_log10(as_half8(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_log10(__clc_vec16_float16_t args_0) {
  return __spirv_ocl_log10(as_half16(args_0));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
