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

_CLC_OVERLOAD _CLC_DEF int __spirv_ocl_ilogb(float x) {
  uint ux = as_uint(x);
  uint ax = ux & EXSIGNBIT_SP32;
  int rs = -118 - (int)__spirv_ocl_clz(ux & MANTBITS_SP32);
  int r = (int)(ax >> EXPSHIFTBITS_SP32) - EXPBIAS_SP32;
  r = ax < 0x00800000U ? rs : r;
  r = ax > EXPBITS_SP32 || ax == 0 ? 0x80000000 : r;
  r = ax == EXPBITS_SP32 ? 0x7fffffff : r;
  return r;
}

_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, int, __spirv_ocl_ilogb, float);

#ifdef cl_khr_fp64
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

_CLC_OVERLOAD _CLC_DEF int __spirv_ocl_ilogb(double x) {
  ulong ux = as_ulong(x);
  ulong ax = ux & ~SIGNBIT_DP64;
  int r = (int)(ax >> EXPSHIFTBITS_DP64) - EXPBIAS_DP64;
  int rs = -1011 - (int)__spirv_ocl_clz(ax & MANTBITS_DP64);
  r = ax < 0x0010000000000000UL ? rs : r;
  r = ax > 0x7ff0000000000000UL || ax == 0UL ? 0x80000000 : r;
  r = ax == 0x7ff0000000000000UL ? 0x7fffffff : r;
  return r;
}

_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, int, __spirv_ocl_ilogb, double);

#endif // cl_khr_fp64

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_DEF _CLC_OVERLOAD int __spirv_ocl_ilogb(half x) {
  float f = x;
  return __spirv_ocl_ilogb(f);
}

_CLC_UNARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, int, __spirv_ocl_ilogb, half)


#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_int32_t
__spirv_ocl_ilogb(__clc_float16_t args_0) {
  return __spirv_ocl_ilogb(as_half(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_int32_t
__spirv_ocl_ilogb(__clc_vec2_float16_t args_0) {
  return __spirv_ocl_ilogb(as_half2(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_int32_t
__spirv_ocl_ilogb(__clc_vec3_float16_t args_0) {
  return __spirv_ocl_ilogb(as_half3(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_int32_t
__spirv_ocl_ilogb(__clc_vec4_float16_t args_0) {
  return __spirv_ocl_ilogb(as_half4(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_int32_t
__spirv_ocl_ilogb(__clc_vec8_float16_t args_0) {
  return __spirv_ocl_ilogb(as_half8(args_0));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_int32_t
__spirv_ocl_ilogb(__clc_vec16_float16_t args_0) {
  return __spirv_ocl_ilogb(as_half16(args_0));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
