//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include <clcmacro.h>
#include <config.h>
#include <math/clc_ldexp.h>
#include <math/math.h>

_CLC_DEFINE_BINARY_BUILTIN(float, __spirv_ocl_ldexp, __clc_ldexp, float, int)
_CLC_DEFINE_BINARY_BUILTIN(float, __spirv_ocl_ldexp, __clc_ldexp, float, uint)

#ifdef cl_khr_fp64

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

_CLC_DEFINE_BINARY_BUILTIN(double, __spirv_ocl_ldexp, __clc_ldexp, double, int)
_CLC_DEFINE_BINARY_BUILTIN(double, __spirv_ocl_ldexp, __clc_ldexp, double, uint)
#endif

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_DEFINE_BINARY_BUILTIN(half, __spirv_ocl_ldexp, __clc_ldexp, half, int)
_CLC_DEFINE_BINARY_BUILTIN(half, __spirv_ocl_ldexp, __clc_ldexp, half, uint)
#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_ldexp(__clc_float16_t args_0, __clc_int32_t args_1) {
  return __spirv_ocl_ldexp(as_half(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_ldexp(__clc_float16_t args_0, __clc_uint32_t args_1) {
  return __spirv_ocl_ldexp(as_half(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_ldexp(__clc_vec2_float16_t args_0, __clc_vec2_int32_t args_1) {
  return __spirv_ocl_ldexp(as_half2(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_ldexp(__clc_vec2_float16_t args_0, __clc_vec2_uint32_t args_1) {
  return __spirv_ocl_ldexp(as_half2(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_ldexp(__clc_vec3_float16_t args_0, __clc_vec3_int32_t args_1) {
  return __spirv_ocl_ldexp(as_half3(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_ldexp(__clc_vec3_float16_t args_0, __clc_vec3_uint32_t args_1) {
  return __spirv_ocl_ldexp(as_half3(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_ldexp(__clc_vec4_float16_t args_0, __clc_vec4_int32_t args_1) {
  return __spirv_ocl_ldexp(as_half4(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_ldexp(__clc_vec4_float16_t args_0, __clc_vec4_uint32_t args_1) {
  return __spirv_ocl_ldexp(as_half4(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_ldexp(__clc_vec8_float16_t args_0, __clc_vec8_int32_t args_1) {
  return __spirv_ocl_ldexp(as_half8(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_ldexp(__clc_vec8_float16_t args_0, __clc_vec8_uint32_t args_1) {
  return __spirv_ocl_ldexp(as_half8(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_ldexp(__clc_vec16_float16_t args_0, __clc_vec16_int32_t args_1) {
  return __spirv_ocl_ldexp(as_half16(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_ldexp(__clc_vec16_float16_t args_0, __clc_vec16_uint32_t args_1) {
  return __spirv_ocl_ldexp(as_half16(args_0), args_1);
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
