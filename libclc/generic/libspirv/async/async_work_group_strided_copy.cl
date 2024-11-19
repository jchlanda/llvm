//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <clc/async/common.h>
#include <spirv/spirv.h>

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_float16_t __local *args_1,
    __clc_float16_t const __global *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_fp16_t __local *)(args_1),
                                (__clc_fp16_t const __global *)(args_2), args_3,
                                args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_float16_t __global *args_1,
    __clc_float16_t const __local *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_fp16_t __global *)(args_1),
                                (__clc_fp16_t const __local *)(args_2), args_3,
                                args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec2_float16_t __local *args_1,
    __clc_vec2_float16_t const __global *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec2_fp16_t __local *)(args_1),
                                (__clc_vec2_fp16_t const __global *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec2_float16_t __global *args_1,
    __clc_vec2_float16_t const __local *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec2_fp16_t __global *)(args_1),
                                (__clc_vec2_fp16_t const __local *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec3_float16_t __local *args_1,
    __clc_vec3_float16_t const __global *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec3_fp16_t __local *)(args_1),
                                (__clc_vec3_fp16_t const __global *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec3_float16_t __global *args_1,
    __clc_vec3_float16_t const __local *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec3_fp16_t __global *)(args_1),
                                (__clc_vec3_fp16_t const __local *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec4_float16_t __local *args_1,
    __clc_vec4_float16_t const __global *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec4_fp16_t __local *)(args_1),
                                (__clc_vec4_fp16_t const __global *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec4_float16_t __global *args_1,
    __clc_vec4_float16_t const __local *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec4_fp16_t __global *)(args_1),
                                (__clc_vec4_fp16_t const __local *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec8_float16_t __local *args_1,
    __clc_vec8_float16_t const __global *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec8_fp16_t __local *)(args_1),
                                (__clc_vec8_fp16_t const __global *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec8_float16_t __global *args_1,
    __clc_vec8_float16_t const __local *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec8_fp16_t __global *)(args_1),
                                (__clc_vec8_fp16_t const __local *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec16_float16_t __local *args_1,
    __clc_vec16_float16_t const __global *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec16_fp16_t __local *)(args_1),
                                (__clc_vec16_fp16_t const __global *)(args_2),
                                args_3, args_4, args_5);
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONVERGENT __clc_event_t __spirv_GroupAsyncCopy(
    __clc_uint32_t args_0, __clc_vec16_float16_t __global *args_1,
    __clc_vec16_float16_t const __local *args_2, __clc_size_t args_3,
    __clc_size_t args_4, __clc_event_t args_5) {
  return __spirv_GroupAsyncCopy(args_0, (__clc_vec16_fp16_t __global *)(args_1),
                                (__clc_vec16_fp16_t const __local *)(args_2),
                                args_3, args_4, args_5);
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16

#define __CLC_BODY <async_work_group_strided_copy.inc>
#define __CLC_GEN_VEC3
#include <clc/async/gentype.inc>
