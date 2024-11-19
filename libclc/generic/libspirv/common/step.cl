//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include <clcmacro.h>

#define STEP_DEF(TYPE, TYPOSTFIX)                                              \
  _CLC_OVERLOAD _CLC_DEF TYPE __spirv_ocl_step(TYPE edge, TYPE x) {            \
    return x < edge ? 0.0##TYPOSTFIX : 1.0##TYPOSTFIX;                         \
  }                                                                            \
  _CLC_BINARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, TYPE, __spirv_ocl_step, TYPE,  \
                        TYPE)

STEP_DEF(float, f)

#ifdef cl_khr_fp64
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

STEP_DEF(double, )

#endif

#ifdef cl_khr_fp16
#pragma OPENCL EXTENSION cl_khr_fp16 : enable

STEP_DEF(half, h)

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_step(__clc_float16_t args_0, __clc_float16_t args_1) {
  return __spirv_ocl_step(as_half(args_0), as_half(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_step(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1) {
  return __spirv_ocl_step(as_half2(args_0), as_half2(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_step(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1) {
  return __spirv_ocl_step(as_half3(args_0), as_half3(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_step(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1) {
  return __spirv_ocl_step(as_half4(args_0), as_half4(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_step(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1) {
  return __spirv_ocl_step(as_half8(args_0), as_half8(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_step(__clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1) {
  return __spirv_ocl_step(as_half16(args_0), as_half16(args_1));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
