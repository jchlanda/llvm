//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>
#include <utils.h>
#include <clcmacro.h>

#define __CLC_BODY <frexp.inc>
#define __CLC_ADDRESS_SPACE private
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE

#define __CLC_BODY <frexp.inc>
#define __CLC_ADDRESS_SPACE global
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE

#define __CLC_BODY <frexp.inc>
#define __CLC_ADDRESS_SPACE local
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
#define __CLC_BODY <frexp.inc>
#define __CLC_ADDRESS_SPACE generic
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE
#endif

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

#define _CLC_DEFINE_NO_VEC(RET_TYPE, FUNCTION, BUILTIN, ARG1_TYPE,     \
                                   ARG2_TYPE)                                  \
  _CLC_DEF _CLC_OVERLOAD RET_TYPE FUNCTION(ARG1_TYPE x, ARG2_TYPE y) {         \
    return BUILTIN(x, y);                                                      \
  }

_CLC_DEFINE_NO_VEC(half, __spirv_ocl_frexp, __builtin_frexp, half, global int *)
_CLC_V_V_VP_VECTORIZE(_CLC_DEF _CLC_OVERLOAD, half, __spirv_ocl_frexp, half, global, int)
_CLC_DEFINE_NO_VEC(half, __spirv_ocl_frexp, __builtin_frexp, half, local int *)
_CLC_V_V_VP_VECTORIZE(_CLC_DEF _CLC_OVERLOAD, half, __spirv_ocl_frexp, half, local, int)
_CLC_DEFINE_NO_VEC(half, __spirv_ocl_frexp, __builtin_frexp, half, int *)
_CLC_V_V_VP_VECTORIZE(_CLC_DEF _CLC_OVERLOAD, half, __spirv_ocl_frexp, half, , int)

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_frexp(__clc_float16_t args_0, __clc_int32_t __private *args_1) {
  return __spirv_ocl_frexp(as_half(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_frexp(__clc_float16_t args_0, __clc_int32_t __local *args_1) {
  return __spirv_ocl_frexp(as_half(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_frexp(__clc_float16_t args_0, __clc_int32_t __global *args_1) {
  return __spirv_ocl_frexp(as_half(args_0), args_1);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_frexp(__clc_float16_t args_0, __clc_int32_t __generic *args_1) {
  return __spirv_ocl_frexp(as_half(args_0), args_1);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t __spirv_ocl_frexp(
    __clc_vec2_float16_t args_0, __clc_vec2_int32_t __private *args_1) {
  return __spirv_ocl_frexp(as_half2(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t __spirv_ocl_frexp(
    __clc_vec2_float16_t args_0, __clc_vec2_int32_t __local *args_1) {
  return __spirv_ocl_frexp(as_half2(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t __spirv_ocl_frexp(
    __clc_vec2_float16_t args_0, __clc_vec2_int32_t __global *args_1) {
  return __spirv_ocl_frexp(as_half2(args_0), args_1);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t __spirv_ocl_frexp(
    __clc_vec2_float16_t args_0, __clc_vec2_int32_t __generic *args_1) {
  return __spirv_ocl_frexp(as_half2(args_0), args_1);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t __spirv_ocl_frexp(
    __clc_vec3_float16_t args_0, __clc_vec3_int32_t __private *args_1) {
  return __spirv_ocl_frexp(as_half3(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t __spirv_ocl_frexp(
    __clc_vec3_float16_t args_0, __clc_vec3_int32_t __local *args_1) {
  return __spirv_ocl_frexp(as_half3(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t __spirv_ocl_frexp(
    __clc_vec3_float16_t args_0, __clc_vec3_int32_t __global *args_1) {
  return __spirv_ocl_frexp(as_half3(args_0), args_1);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t __spirv_ocl_frexp(
    __clc_vec3_float16_t args_0, __clc_vec3_int32_t __generic *args_1) {
  return __spirv_ocl_frexp(as_half3(args_0), args_1);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t __spirv_ocl_frexp(
    __clc_vec4_float16_t args_0, __clc_vec4_int32_t __private *args_1) {
  return __spirv_ocl_frexp(as_half4(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t __spirv_ocl_frexp(
    __clc_vec4_float16_t args_0, __clc_vec4_int32_t __local *args_1) {
  return __spirv_ocl_frexp(as_half4(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t __spirv_ocl_frexp(
    __clc_vec4_float16_t args_0, __clc_vec4_int32_t __global *args_1) {
  return __spirv_ocl_frexp(as_half4(args_0), args_1);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t __spirv_ocl_frexp(
    __clc_vec4_float16_t args_0, __clc_vec4_int32_t __generic *args_1) {
  return __spirv_ocl_frexp(as_half4(args_0), args_1);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t __spirv_ocl_frexp(
    __clc_vec8_float16_t args_0, __clc_vec8_int32_t __private *args_1) {
  return __spirv_ocl_frexp(as_half8(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t __spirv_ocl_frexp(
    __clc_vec8_float16_t args_0, __clc_vec8_int32_t __local *args_1) {
  return __spirv_ocl_frexp(as_half8(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t __spirv_ocl_frexp(
    __clc_vec8_float16_t args_0, __clc_vec8_int32_t __global *args_1) {
  return __spirv_ocl_frexp(as_half8(args_0), args_1);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t __spirv_ocl_frexp(
    __clc_vec8_float16_t args_0, __clc_vec8_int32_t __generic *args_1) {
  return __spirv_ocl_frexp(as_half8(args_0), args_1);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t __spirv_ocl_frexp(
    __clc_vec16_float16_t args_0, __clc_vec16_int32_t __private *args_1) {
  return __spirv_ocl_frexp(as_half16(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t __spirv_ocl_frexp(
    __clc_vec16_float16_t args_0, __clc_vec16_int32_t __local *args_1) {
  return __spirv_ocl_frexp(as_half16(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t __spirv_ocl_frexp(
    __clc_vec16_float16_t args_0, __clc_vec16_int32_t __global *args_1) {
  return __spirv_ocl_frexp(as_half16(args_0), args_1);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t __spirv_ocl_frexp(
    __clc_vec16_float16_t args_0, __clc_vec16_int32_t __generic *args_1) {
  return __spirv_ocl_frexp(as_half16(args_0), args_1);
}
#endif

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
