//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include <math/clc_tan.h>

#define __CLC_FUNC __spirv_ocl_tan
#define __CLC_SW_FUNC __clc_tan
#define __CLC_BODY <clc_sw_unary.inc>
#include <clc/math/gentype.inc>
#undef __CLC_SW_FUNC

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_tan(__clc_float16_t args_0) {
  return __spirv_ocl_tan(as_half(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_tan(__clc_vec2_float16_t args_0) {
  return __spirv_ocl_tan(as_half2(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_tan(__clc_vec3_float16_t args_0) {
  return __spirv_ocl_tan(as_half3(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_tan(__clc_vec4_float16_t args_0) {
  return __spirv_ocl_tan(as_half4(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_tan(__clc_vec8_float16_t args_0) {
  return __spirv_ocl_tan(as_half8(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_tan(__clc_vec16_float16_t args_0) {
  return __spirv_ocl_tan(as_half16(args_0));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
