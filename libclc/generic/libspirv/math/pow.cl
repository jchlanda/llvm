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
#include <math/clc_pow.h>
#include <math/math.h>

#define __CLC_BODY <pow.inc>
#include <clc/math/gentype.inc>

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_pow(__clc_float16_t args_0, __clc_float16_t args_1) {
  return __spirv_ocl_pow(as_half(args_0), as_half(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_pow(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1) {
  return __spirv_ocl_pow(as_half2(args_0), as_half2(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_pow(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1) {
  return __spirv_ocl_pow(as_half3(args_0), as_half3(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_pow(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1) {
  return __spirv_ocl_pow(as_half4(args_0), as_half4(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_pow(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1) {
  return __spirv_ocl_pow(as_half8(args_0), as_half8(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_pow(__clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1) {
  return __spirv_ocl_pow(as_half16(args_0), as_half16(args_1));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
