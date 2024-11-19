//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <clcmacro.h>
#include <spirv/spirv.h>

#define _CLC_GEN_VECTORTIMESSCALAR_IMPL(DECLSPEC, TYPE, VECLEN)                \
  DECLSPEC TYPE##VECLEN __spirv_VectorTimesScalar(TYPE##VECLEN x, TYPE y) {    \
    return x * (TYPE##VECLEN)y;                                                \
  }

#define _CLC_GEN_VECTORTIMESSCALAR(DECLSPEC, TYPE)                             \
  _CLC_GEN_VECTORTIMESSCALAR_IMPL(DECLSPEC, TYPE, 2)                           \
  _CLC_GEN_VECTORTIMESSCALAR_IMPL(DECLSPEC, TYPE, 3)                           \
  _CLC_GEN_VECTORTIMESSCALAR_IMPL(DECLSPEC, TYPE, 4)                           \
  _CLC_GEN_VECTORTIMESSCALAR_IMPL(DECLSPEC, TYPE, 8)                           \
  _CLC_GEN_VECTORTIMESSCALAR_IMPL(DECLSPEC, TYPE, 16)

_CLC_GEN_VECTORTIMESSCALAR(_CLC_OVERLOAD _CLC_DEF, float)

#ifdef cl_khr_fp64

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

_CLC_GEN_VECTORTIMESSCALAR(_CLC_OVERLOAD _CLC_DEF, double)

#endif

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_GEN_VECTORTIMESSCALAR(_CLC_OVERLOAD _CLC_DEF, half)

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_VectorTimesScalar(__clc_vec2_float16_t args_0, __clc_float16_t args_1) {
  return __spirv_VectorTimesScalar(as_half2(args_0), as_half(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_VectorTimesScalar(__clc_vec3_float16_t args_0, __clc_float16_t args_1) {
  return __spirv_VectorTimesScalar(as_half3(args_0), as_half(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_VectorTimesScalar(__clc_vec4_float16_t args_0, __clc_float16_t args_1) {
  return __spirv_VectorTimesScalar(as_half4(args_0), as_half(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_VectorTimesScalar(__clc_vec8_float16_t args_0, __clc_float16_t args_1) {
  return __spirv_VectorTimesScalar(as_half8(args_0), as_half(args_1));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_VectorTimesScalar(__clc_vec16_float16_t args_0,
                          __clc_float16_t args_1) {
  return __spirv_VectorTimesScalar(as_half16(args_0), as_half(args_1));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
