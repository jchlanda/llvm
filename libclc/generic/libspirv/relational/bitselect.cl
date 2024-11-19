//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#include <clcmacro.h>

#define __CLC_BODY <bitselect.inc>
#include <clc/integer/gentype.inc>
#undef __CLC_BODY

#define FLOAT_BITSELECT(f_type, i_type, width)                                 \
  _CLC_OVERLOAD _CLC_DEF f_type##width __spirv_ocl_bitselect(                  \
      f_type##width x, f_type##width y, f_type##width z) {                     \
    return as_##f_type##width(__spirv_ocl_bitselect(                           \
        as_##i_type##width(x), as_##i_type##width(y), as_##i_type##width(z))); \
  }

FLOAT_BITSELECT(float, uint, )
FLOAT_BITSELECT(float, uint, 2)
FLOAT_BITSELECT(float, uint, 3)
FLOAT_BITSELECT(float, uint, 4)
FLOAT_BITSELECT(float, uint, 8)
FLOAT_BITSELECT(float, uint, 16)

#ifdef cl_khr_fp64
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

FLOAT_BITSELECT(double, ulong, )
FLOAT_BITSELECT(double, ulong, 2)
FLOAT_BITSELECT(double, ulong, 3)
FLOAT_BITSELECT(double, ulong, 4)
FLOAT_BITSELECT(double, ulong, 8)
FLOAT_BITSELECT(double, ulong, 16)

#endif

#ifdef cl_khr_fp16
#pragma OPENCL EXTENSION cl_khr_fp16 : enable

FLOAT_BITSELECT(half, ushort, )
FLOAT_BITSELECT(half, ushort, 2)
FLOAT_BITSELECT(half, ushort, 3)
FLOAT_BITSELECT(half, ushort, 4)
FLOAT_BITSELECT(half, ushort, 8)
FLOAT_BITSELECT(half, ushort, 16)

#endif

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_fp16_t __spirv_ocl_bitselect(
    __clc_float16_t args_0, __clc_float16_t args_1, __clc_float16_t args_2) {
  return __spirv_ocl_bitselect(as_half(args_0), as_half(args_1),
                               as_half(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec2_fp16_t
__spirv_ocl_bitselect(__clc_vec2_float16_t args_0, __clc_vec2_float16_t args_1,
                      __clc_vec2_float16_t args_2) {
  return __spirv_ocl_bitselect(as_half2(args_0), as_half2(args_1),
                               as_half2(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec3_fp16_t
__spirv_ocl_bitselect(__clc_vec3_float16_t args_0, __clc_vec3_float16_t args_1,
                      __clc_vec3_float16_t args_2) {
  return __spirv_ocl_bitselect(as_half3(args_0), as_half3(args_1),
                               as_half3(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec4_fp16_t
__spirv_ocl_bitselect(__clc_vec4_float16_t args_0, __clc_vec4_float16_t args_1,
                      __clc_vec4_float16_t args_2) {
  return __spirv_ocl_bitselect(as_half4(args_0), as_half4(args_1),
                               as_half4(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec8_fp16_t
__spirv_ocl_bitselect(__clc_vec8_float16_t args_0, __clc_vec8_float16_t args_1,
                      __clc_vec8_float16_t args_2) {
  return __spirv_ocl_bitselect(as_half8(args_0), as_half8(args_1),
                               as_half8(args_2));
}

_CLC_OVERLOAD _CLC_DEF _CLC_CONSTFN __clc_vec16_fp16_t __spirv_ocl_bitselect(
    __clc_vec16_float16_t args_0, __clc_vec16_float16_t args_1,
    __clc_vec16_float16_t args_2) {
  return __spirv_ocl_bitselect(as_half16(args_0), as_half16(args_1),
                               as_half16(args_2));
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
