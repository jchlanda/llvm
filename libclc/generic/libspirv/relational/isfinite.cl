//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <relational.h>
#include <spirv/spirv.h>

#define _CLC_SPIRV_BUILTIN __spirv_IsFinite
#define _CLC_BUILTIN_IMPL __builtin_isfinite

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_bool_t
__spirv_IsFinite(__clc_float16_t args_0) {
  return __spirv_IsFinite(as_half(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_int8_t
__spirv_IsFinite(__clc_vec2_float16_t args_0) {
  return __spirv_IsFinite(as_half2(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_int8_t
__spirv_IsFinite(__clc_vec3_float16_t args_0) {
  return __spirv_IsFinite(as_half3(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_int8_t
__spirv_IsFinite(__clc_vec4_float16_t args_0) {
  return __spirv_IsFinite(as_half4(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_int8_t
__spirv_IsFinite(__clc_vec8_float16_t args_0) {
  return __spirv_IsFinite(as_half8(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_int8_t
__spirv_IsFinite(__clc_vec16_float16_t args_0) {
  return __spirv_IsFinite(as_half16(args_0));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16

#include "genunary.inc"
