; RUN: %if hip_amd %{ env SYCL_MATERIALIZER_DEBUG=1 opt\
; RUN: -load-pass-plugin %shlibdir/SYCLKernelFusion%shlibext\
; RUN: --mtriple amdgcn-amd-amdhsa -sycl-materializer-debug-value-size=256\
; RUN: -passes=sycl-spec-const-materializer,sccp -S %s 2> %t.stderr\
; RUN: | FileCheck %s %}
; RUN: %if hip_amd %{ FileCheck --input-file=%t.stderr --check-prefix=CHECK-DEBUG %s %}

; RUN: %if cuda %{ env SYCL_MATERIALIZER_DEBUG=1 opt\
; RUN: -load-pass-plugin %shlibdir/SYCLKernelFusion%shlibext\
; RUN: --mtriple nvptx64-nvidia-cuda -sycl-materializer-debug-value-size=256\
; RUN: -passes=sycl-spec-const-materializer,sccp -S %s 2> %t.stderr\
; RUN: | FileCheck %s %}
; RUN: %if hip_amd %{ FileCheck --input-file=%t.stderr --check-prefix=CHECK-DEBUG %s %}

source_filename = "debug_output.ll"
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"

; This is a derivative of basic.ll, which check for the debug output of
; specialization constant materializer pass.

;CHECK-DEBUG: Working on kernel:
;CHECK-DEBUG-NEXT: ==================
;CHECK-DEBUG-NEXT: __test_kernel
;CHECK-DEBUG: Replaced: 2 loads from spec const buffer.
;CHECK-DEBUG-NEXT: Load to global variable mappings:
;CHECK-DEBUG-NEXT:         Load:
;CHECK-DEBUG-NEXT:   %load1 = load i32, ptr %bc, align 4
;CHECK-DEBUG-NEXT:         Global Variable:
;CHECK-DEBUG-NEXT: @SpecConsBlob___test_kernel_0 = weak_odr addrspace(4) constant i32 50462976, align 4
;CHECK-DEBUG:         Load:
;CHECK-DEBUG-NEXT:   %load2 = load [2 x i32], ptr %bc2, align 4
;CHECK-DEBUG-NEXT:         Global Variable:
;CHECK-DEBUG-NEXT: @SpecConsBlob___test_kernel_1 = weak_odr addrspace(4) constant [2 x i32] [i32 117835012, i32 185207048], align 4

;CHECK:@SpecConsBlob___test_kernel_0 = weak_odr addrspace(4) constant i32 50462976
;CHECK: @SpecConsBlob___test_kernel_1 = weak_odr addrspace(4) constant [2 x i32] [i32 117835012, i32 185207048], align 4


;CHECK: __test_kernel
define weak_odr protected amdgpu_kernel void @__test_kernel(ptr addrspace(1) noundef align 4 %out, ptr addrspace(1) noundef align 1 %_arg__specialization_constants_buffer) {
entry:
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
