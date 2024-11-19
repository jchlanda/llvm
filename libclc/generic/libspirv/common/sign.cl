//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <clcmacro.h>
#include <spirv/spirv.h>

#define SIGN(TYPE, F)                                                          \
  _CLC_DEF _CLC_OVERLOAD TYPE __spirv_ocl_sign(TYPE x) {                       \
    if (__spirv_IsNan(x)) {                                                    \
      return 0.0F;                                                             \
    }                                                                          \
    if (x > 0.0F) {                                                            \
      return 1.0F;                                                             \
    }                                                                          \
    if (x < 0.0F) {                                                            \
      return -1.0F;                                                            \
    }                                                                          \
    return x; /* -0.0 or +0.0 */                                               \
  }

SIGN(float, f)
_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, float, __spirv_ocl_sign, float)

#ifdef cl_khr_fp64

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

SIGN(double, )
_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, double, __spirv_ocl_sign, double)

#endif

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

SIGN(half, h)
_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, half, __spirv_ocl_sign, half)

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_sign(__clc_float16_t args_0) {
  return __spirv_ocl_sign(as_half(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_sign(__clc_vec2_float16_t args_0) {
  return __spirv_ocl_sign(as_half2(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_sign(__clc_vec3_float16_t args_0) {
  return __spirv_ocl_sign(as_half3(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_sign(__clc_vec4_float16_t args_0) {
  return __spirv_ocl_sign(as_half4(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_sign(__clc_vec8_float16_t args_0) {
  return __spirv_ocl_sign(as_half8(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_sign(__clc_vec16_float16_t args_0) {
  return __spirv_ocl_sign(as_half16(args_0));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
