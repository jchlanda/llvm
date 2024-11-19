//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include <clcmacro.h>

_CLC_OVERLOAD _CLC_DEF float __spirv_ocl_smoothstep(float edge0, float edge1,
                                                    float x) {
  float t = __spirv_ocl_fclamp((x - edge0) / (edge1 - edge0), 0.0f, 1.0f);
  return t * t * (3.0f - 2.0f * t);
}

_CLC_TERNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, float, __spirv_ocl_smoothstep,
                       float, float, float)

#ifdef cl_khr_fp64
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

_CLC_OVERLOAD _CLC_DEF double __spirv_ocl_smoothstep(double edge0, double edge1,
                                                     double x) {
  double t = __spirv_ocl_fclamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
  return t * t * (3.0 - 2.0 * t);
}

_CLC_TERNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, double, __spirv_ocl_smoothstep,
                       double, double, double)

#endif

#ifdef cl_khr_fp16
#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF half __spirv_ocl_smoothstep(half edge0, half edge1,
                                                   half x) {
  half t = __spirv_ocl_fclamp((x - edge0) / (edge1 - edge0), 0.0h, 1.0h);
  return t * t * (3.0h - 2.0h * t);
}

_CLC_TERNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, half, __spirv_ocl_smoothstep,
                       half, half, half);

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable


_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t __spirv_ocl_smoothstep(
    __clc_float16_t args_0, __clc_float16_t args_1, __clc_float16_t args_2) {
  return __spirv_ocl_smoothstep(as_half(args_0), as_half(args_1),
                                as_half(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_smoothstep(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1,
                       __clc_vec2_float16_t args_2) {
  return __spirv_ocl_smoothstep(as_half2(args_0), as_half2(args_1),
                                as_half2(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_smoothstep(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1,
                       __clc_vec3_float16_t args_2) {
  return __spirv_ocl_smoothstep(as_half3(args_0), as_half3(args_1),
                                as_half3(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_smoothstep(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1,
                       __clc_vec4_float16_t args_2) {
  return __spirv_ocl_smoothstep(as_half4(args_0), as_half4(args_1),
                                as_half4(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_smoothstep(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1,
                       __clc_vec8_float16_t args_2) {
  return __spirv_ocl_smoothstep(as_half8(args_0), as_half8(args_1),
                                as_half8(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t __spirv_ocl_smoothstep(
    __clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1,
    __clc_vec16_float16_t args_2) {
  return __spirv_ocl_smoothstep(as_half16(args_0), as_half16(args_1),
                                as_half16(args_2));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
