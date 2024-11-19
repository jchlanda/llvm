//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include <math/clc_remquo.h>

#define __CLC_BODY <remquo.inc>
#define __CLC_ADDRESS_SPACE global
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE

#define __CLC_BODY <remquo.inc>
#define __CLC_ADDRESS_SPACE local
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE

#define __CLC_BODY <remquo.inc>
#define __CLC_ADDRESS_SPACE private
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
#define __CLC_BODY <remquo.inc>
#define __CLC_ADDRESS_SPACE generic
#include <clc/math/gentype.inc>
#undef __CLC_ADDRESS_SPACE
#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_remquo(__clc_float16_t args_0, __clc_float16_t args_1,
                   __clc_int32_t __private *args_2) {
  return __spirv_ocl_remquo(as_half(args_0), as_half(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_remquo(__clc_float16_t args_0, __clc_float16_t args_1,
                   __clc_int32_t __local *args_2) {
  return __spirv_ocl_remquo(as_half(args_0), as_half(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_remquo(__clc_float16_t args_0, __clc_float16_t args_1,
                   __clc_int32_t __global *args_2) {
  return __spirv_ocl_remquo(as_half(args_0), as_half(args_1), args_2);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_fp16_t
__spirv_ocl_remquo(__clc_float16_t args_0, __clc_float16_t args_1,
                   __clc_int32_t __generic *args_2) {
  return __spirv_ocl_remquo(as_half(args_0), as_half(args_1), args_2);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t
__spirv_ocl_remquo(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1,
                   __clc_vec2_int32_t __private *args_2) {
  return __spirv_ocl_remquo(as_half2(args_0), as_half2(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t
__spirv_ocl_remquo(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1,
                   __clc_vec2_int32_t __local *args_2) {
  return __spirv_ocl_remquo(as_half2(args_0), as_half2(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t
__spirv_ocl_remquo(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1,
                   __clc_vec2_int32_t __global *args_2) {
  return __spirv_ocl_remquo(as_half2(args_0), as_half2(args_1), args_2);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec2_fp16_t
__spirv_ocl_remquo(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1,
                   __clc_vec2_int32_t __generic *args_2) {
  return __spirv_ocl_remquo(as_half2(args_0), as_half2(args_1), args_2);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t
__spirv_ocl_remquo(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1,
                   __clc_vec3_int32_t __private *args_2) {
  return __spirv_ocl_remquo(as_half3(args_0), as_half3(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t
__spirv_ocl_remquo(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1,
                   __clc_vec3_int32_t __local *args_2) {
  return __spirv_ocl_remquo(as_half3(args_0), as_half3(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t
__spirv_ocl_remquo(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1,
                   __clc_vec3_int32_t __global *args_2) {
  return __spirv_ocl_remquo(as_half3(args_0), as_half3(args_1), args_2);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec3_fp16_t
__spirv_ocl_remquo(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1,
                   __clc_vec3_int32_t __generic *args_2) {
  return __spirv_ocl_remquo(as_half3(args_0), as_half3(args_1), args_2);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t
__spirv_ocl_remquo(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1,
                   __clc_vec4_int32_t __private *args_2) {
  return __spirv_ocl_remquo(as_half4(args_0), as_half4(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t
__spirv_ocl_remquo(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1,
                   __clc_vec4_int32_t __local *args_2) {
  return __spirv_ocl_remquo(as_half4(args_0), as_half4(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t
__spirv_ocl_remquo(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1,
                   __clc_vec4_int32_t __global *args_2) {
  return __spirv_ocl_remquo(as_half4(args_0), as_half4(args_1), args_2);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec4_fp16_t
__spirv_ocl_remquo(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1,
                   __clc_vec4_int32_t __generic *args_2) {
  return __spirv_ocl_remquo(as_half4(args_0), as_half4(args_1), args_2);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t
__spirv_ocl_remquo(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1,
                   __clc_vec8_int32_t __private *args_2) {
  return __spirv_ocl_remquo(as_half8(args_0), as_half8(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t
__spirv_ocl_remquo(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1,
                   __clc_vec8_int32_t __local *args_2) {
  return __spirv_ocl_remquo(as_half8(args_0), as_half8(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t
__spirv_ocl_remquo(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1,
                   __clc_vec8_int32_t __global *args_2) {
  return __spirv_ocl_remquo(as_half8(args_0), as_half8(args_1), args_2);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec8_fp16_t
__spirv_ocl_remquo(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1,
                   __clc_vec8_int32_t __generic *args_2) {
  return __spirv_ocl_remquo(as_half8(args_0), as_half8(args_1), args_2);
}
#endif

_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t
__spirv_ocl_remquo(__clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1,
                   __clc_vec16_int32_t __private *args_2) {
  return __spirv_ocl_remquo(as_half16(args_0), as_half16(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t
__spirv_ocl_remquo(__clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1,
                   __clc_vec16_int32_t __local *args_2) {
  return __spirv_ocl_remquo(as_half16(args_0), as_half16(args_1), args_2);
}

_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t
__spirv_ocl_remquo(__clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1,
                   __clc_vec16_int32_t __global *args_2) {
  return __spirv_ocl_remquo(as_half16(args_0), as_half16(args_1), args_2);
}

#if _CLC_DISTINCT_GENERIC_AS_SUPPORTED
_CLC_OVERLOAD _CLC_DEF __clc_vec16_fp16_t
__spirv_ocl_remquo(__clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1,
                   __clc_vec16_int32_t __generic *args_2) {
  return __spirv_ocl_remquo(as_half16(args_0), as_half16(args_1), args_2);
}
#endif

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
