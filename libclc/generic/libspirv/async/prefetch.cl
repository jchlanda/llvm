//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <spirv/spirv.h>

#define __CLC_BODY <prefetch.inc>
#define __CLC_GEN_VEC3
#include <clc/async/gentype.inc>

#ifdef cl_khr_fp16
#ifdef __CLC_HAS_FLOAT16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_OVERLOAD _CLC_DEF void
__spirv_ocl_prefetch(__clc_float16_t const __global *args_0,
                     __clc_size_t args_1) {
  __spirv_ocl_prefetch((__clc_fp16_t const __global *)(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF void
__spirv_ocl_prefetch(__clc_vec2_float16_t const __global *args_0,
                     __clc_size_t args_1) {
  __spirv_ocl_prefetch((__clc_vec2_fp16_t const __global *)(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF void
__spirv_ocl_prefetch(__clc_vec3_float16_t const __global *args_0,
                     __clc_size_t args_1) {
  __spirv_ocl_prefetch((__clc_vec3_fp16_t const __global *)(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF void
__spirv_ocl_prefetch(__clc_vec4_float16_t const __global *args_0,
                     __clc_size_t args_1) {
  __spirv_ocl_prefetch((__clc_vec4_fp16_t const __global *)(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF void
__spirv_ocl_prefetch(__clc_vec8_float16_t const __global *args_0,
                     __clc_size_t args_1) {
  __spirv_ocl_prefetch((__clc_vec8_fp16_t const __global *)(args_0), args_1);
}

_CLC_OVERLOAD _CLC_DEF void
__spirv_ocl_prefetch(__clc_vec16_float16_t const __global *args_0,
                     __clc_size_t args_1) {
  __spirv_ocl_prefetch((__clc_vec16_fp16_t const __global *)(args_0), args_1);
}

#endif // __CLC_HAS_FLOAT16
#endif // cl_khr_fp16
