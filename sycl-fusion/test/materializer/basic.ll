; RUN: %if hip_amd %{ opt -load-pass-plugin %shlibdir/SYCLKernelFusion%shlibext\
; RUN: --mtriple amdgcn-amd-amdhsa -sycl-materializer-debug-value-size=256\
; RUN: -passes=sycl-spec-const-materializer,sccp -S %s | FileCheck %s %}

; RUN: %if cuda %{ opt -load-pass-plugin %shlibdir/SYCLKernelFusion%shlibext\
; RUN: --mtriple nvptx64-nvidia-cuda -sycl-materializer-debug-value-size=256\
; RUN: -passes=sycl-spec-const-materializer,sccp -S %s | FileCheck %s %}

source_filename = "basic.ll"
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"

; Check the basic replacement of specialization constant. We expect 2 global
; variables (i32 and [2 x i32]), no loads from implicit kernel argument and
; direct use of literals in IR.

; 50462976 is: 0b11000000100000000100000000 which corresponds to a sequence
; of 0, 1, 2... (broken concatenated on byte level) as set by the default
; constructor of the pass.
;CHECK:@SpecConsBlob___test_kernel_0 = weak_odr addrspace(4) constant i32 50462976
; similarly 117835012: 0b111000001100000010100000100 -> 4, 5, 6...
;CHECK: @SpecConsBlob___test_kernel_1 = weak_odr addrspace(4) constant [2 x i32] [i32 117835012, i32 185207048], align 4


;CHECK: __test_kernel
define weak_odr protected amdgpu_kernel void @__test_kernel(ptr addrspace(1) noundef align 4 %out, ptr addrspace(1) noundef align 1 %_arg__specialization_constants_buffer) {
entry:
  ;CHECK-NOT: addrspacecast ptr addrspace(1) %_arg__specialization_constants_buffer to ptr
  ; CHECK-NOT: load i32
  ; CHECK-NOT: load [2 x i32]
  %0 = addrspacecast ptr addrspace(1) %_arg__specialization_constants_buffer to ptr
  %gep = getelementptr i8, ptr %0, i32 0
  %bc = bitcast ptr %gep to ptr
  %load1 = load i32, ptr %bc, align 4
  %gep1 = getelementptr i8, ptr %0, i32 4
  %bc2 = bitcast ptr %gep1 to ptr
  %load2 = load [2 x i32], ptr %bc2, align 4
  ;CHECK: extractvalue [2 x i32] [i32 117835012, i32 185207048], 0
  ;CHECK: extractvalue [2 x i32] [i32 117835012, i32 185207048], 1
  ;CHECK: add nsw i32 %extract1, 50462976
  %extract1 = extractvalue [2 x i32] %load2, 0
  %extract2 = extractvalue [2 x i32] %load2, 1
  %add1 = add nsw i32 %extract1, %load1
  %add2 = add nsw i32 %add1, %extract2
  store i32 %add2, ptr addrspace(1) %out, align 4
  ret void
}
