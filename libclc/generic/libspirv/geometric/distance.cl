//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_distance(__clc_float16_t args_0, __clc_float16_t args_1) {
  return __spirv_ocl_distance(as_half(args_0), as_half(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_distance(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1) {
  return __spirv_ocl_distance(as_half2(args_0), as_half2(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_distance(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1) {
  return __spirv_ocl_distance(as_half3(args_0), as_half3(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_distance(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1) {
  return __spirv_ocl_distance(as_half4(args_0), as_half4(args_1));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16

#define __CLC_BODY <distance.inc>
#include <clc/geometric/floatn.inc>
