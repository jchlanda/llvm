//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include <clcmacro.h>
#include <math/math.h>

_CLC_OVERLOAD _CLC_DEF float __spirv_ocl_tgamma(float x) {
  const float pi = 3.1415926535897932384626433832795f;
  float ax = __spirv_ocl_fabs(x);
  float lg = __spirv_ocl_lgamma(ax);
  float g = __spirv_ocl_exp(lg);

  if (x < 0.0f) {
    float z = __spirv_ocl_sinpi(x);
    g = g * ax * z;
    g = pi / g;
    g = g == 0 ? as_float(PINFBITPATT_SP32) : g;
    g = z == 0 ? as_float(QNANBITPATT_SP32) : g;
  }

  return g;
}

_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, float, __spirv_ocl_tgamma, float);

#ifdef cl_khr_fp64

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

_CLC_OVERLOAD _CLC_DEF double __spirv_ocl_tgamma(double x) {
  const double pi = 3.1415926535897932384626433832795;
  double ax = __spirv_ocl_fabs(x);
  double lg = __spirv_ocl_lgamma(ax);
  double g = __spirv_ocl_exp(lg);

  if (x < 0.0) {
    double z = __spirv_ocl_sinpi(x);
    g = g * ax * z;
    g = pi / g;
    g = g == 0 ? as_double(PINFBITPATT_DP64) : g;
    g = z == 0 ? as_double(QNANBITPATT_DP64) : g;
  }

  return g;
}

_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, double, __spirv_ocl_tgamma,
                     double);

#endif

#ifdef cl_khr_fp16
#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_DEF _CLC_OVERLOAD half __spirv_ocl_tgamma(half x) {
  return __spirv_ocl_tgamma((float)x);
}

_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, half, __spirv_ocl_tgamma, half)

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t
__spirv_ocl_tgamma(__clc_float16_t args_0) {
  return __spirv_ocl_tgamma(as_half(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_tgamma(__clc_vec2_float16_t args_0) {
  return __spirv_ocl_tgamma(as_half2(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_tgamma(__clc_vec3_float16_t args_0) {
  return __spirv_ocl_tgamma(as_half3(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_tgamma(__clc_vec4_float16_t args_0) {
  return __spirv_ocl_tgamma(as_half4(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_tgamma(__clc_vec8_float16_t args_0) {
  return __spirv_ocl_tgamma(as_half8(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t
__spirv_ocl_tgamma(__clc_vec16_float16_t args_0) {
  return __spirv_ocl_tgamma(as_half16(args_0));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
