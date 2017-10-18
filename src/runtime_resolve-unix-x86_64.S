// This file is a part of Julia. License is MIT: https://julialang.org/license
//
// This is the runtime resolve callback for x86_64 arch on unix (BSD, Linux) following the
// AMD64 calling convention.
//
// Classification of general purpose registers:
// * Used in argument passing:
//
//   %rdi, %rsi, %rdx, %rcx, %r8, %r9, %rax, %r10
//
//   Among these %rdi, %rsi, %rdx, %rcx, %r8, %r9 are used to pass integer parameters
//   %rax is used to pass the number of fp/vector vararg arguments
//   %r10 is used by GCC nested function extension.
//   Not sure if we care much about %r10 but it's not particularly hard to handle
//   and it's mentioned in the ABI so let's not mess with it...
//
// * Callee save
//
//   %rsp, %rbp, %rbx, %r12, %r13, %r14, %r15
//
// This leave us with one register that can be used without having to restore it: %r11.
// This function is only called from LLVM generated code which should handle stack alignment
// correctly so we don't need to align the stack.

        .hidden jl_runtime_resolve_fp
        .comm   jl_runtime_resolve_fp, 8, 8
        .text
        .hidden jl_runtime_resolve
        .globl  jl_runtime_resolve
        .type   jl_runtime_resolve, @function
jl_runtime_resolve:
        .cfi_startproc
        sub    $0x88, %rsp
        .cfi_def_cfa_offset 144
        // Save integer registers in 0x0 to 0x38
        mov    %r9, (%rsp)
        mov    %r8, 0x8(%rsp)
        mov    %rdx, 0x10(%rsp)
        mov    %rcx, 0x18(%rsp)
        mov    %rsi, 0x20(%rsp)
        mov    %rdi, 0x28(%rsp)
        mov    %rax, 0x30(%rsp)  // Used for vararg function

        // Save MPX bounds registers in 0x40 to 0x80
#ifdef JULIA_HAS_MPX_SUPPORT
        bndmov %bnd0, 0x40(%rsp)
        bndmov %bnd1, 0x50(%rsp)
        bndmov %bnd2, 0x60(%rsp)
        bndmov %bnd3, 0x70(%rsp)
#else
        .byte 0x66, 0x0f, 0x1b, 0x44, 0x24, 0x40
        .byte 0x66, 0x0f, 0x1b, 0x4c, 0x24, 0x50
        .byte 0x66, 0x0f, 0x1b, 0x54, 0x24, 0x60
        .byte 0x66, 0x0f, 0x1b, 0x5c, 0x24, 0x70
#endif
        // Save and restore floatingpoint/vector arguments
        // This is different depending on the available features on the CPU
        // In addition to having to save different register sizes, we also need to avoid
        // the issue of partial register access on intel CPUs

        // An obvious option is to use `xsaveopt`/`xsaves`.
        // However, according to multiple source
        // (e.g. http://permalink.gmane.org/gmane.linux.kernel.commits.head/476505)
        // the optimization used in these instructions aren't valid in userspace so we have to
        // save and restore each registers individually.
        // We don't necessarily care how fast this function runs, or even how fast the real
        // resolve function runs since it's a single time cost.
        // However, we do care about the possible performance impact on code running
        // after this function which can be pretty bad if we are not careful enough.

        // The performance impact from mixing code that access different register size
        // is an intel specific issue (no existing AMD processor has this issue)
        // and it changes a lot depending on the model of the processor.
        // The different microarch behaviors includes
        // (only processors with both SSE and AVX matters so pre-AVX processors are ignored):
        //
        // 1. Pre-Skylake Core/Xeon:
        //
        //     If any ymm registers are accessed (include **read**),
        //     there is a one time transition penalty
        //     when executing legacy SSE instructions that access XMM registers
        //
        //     `vzeroupper` on these processors are cheap.
        //
        // 2. Skylake and later processors with or without AVX512
        //
        //     If any of the upper bits of any ymm / zmm registers are not known to be 0
        //     (unclear if reading the ymm / zmm register can mark them dirty)
        //     There's a persistent cost when running **ANY** sse instructions that
        //     modifies xmm registers (serialization and blending penalty),
        //     which can make them run 2x-8x slower!
        //
        //     `vzeroupper` on these processors are cheap.
        //     `xgetbv` with `ecx == 1` should always be available.
        //
        // 3. Knights Landing (and possibly later Xeon Phi processors)
        //
        //     There shouldn't be a penalty mixing avx/avx512/sse code.
        //     The caller/callee is more likely to be avx512 aware.
        //
        //     `vzeroupper` is slow, not needed to avoid any penalty and
        //     not recommended by intel manual.
        //     Unclear if `xgetbv` with `ecx == 1` is available.
        //
        // This means that on processors without AVX512, we can always just directly check
        // if the upper bits of the registers are 0 and use `vzeroupper` to reset the
        // dirty state if we only need to save `xmm`s.
        // This is implemented below in `jl_runtime_resolve_fp_avx`.
        //
        // For AVX512, we don't want to unconditionally use `vzeroupper`. However, since
        // all processor that has a transition / mixing penalty with AVX512 should support
        // `xgetbv` with `ecx == 1`, we can use that to check the upper bits of the registers
        // when it's available (`jl_runtime_resolve_fp_avx512_xg1`).
        // On processors without it, we can just save the whole `zmm` registers
        // since it shouldn't cause a performance issue. (`jl_runtime_resolve_fp_avx512`).
        jmp    *jl_runtime_resolve_fp(%rip)

        .hidden jl_runtime_resolve_fp_sse
        .globl  jl_runtime_resolve_fp_sse
jl_runtime_resolve_fp_sse:
        .cfi_remember_state
        sub    $0x80, %rsp
        .cfi_adjust_cfa_offset 128
        movups %xmm0, (%rsp)
        movups %xmm1, 0x10(%rsp)
        movups %xmm2, 0x20(%rsp)
        movups %xmm3, 0x30(%rsp)
        movups %xmm4, 0x40(%rsp)
        movups %xmm5, 0x50(%rsp)
        movups %xmm6, 0x60(%rsp)
        movups %xmm7, 0x70(%rsp)

        mov    %r11, %rdi       // %r11 was a pointer to the function info
        call   jl_runtime_resolve_real
        mov    %rax, %r11       // Now %r11 is the result function pointer

        movups (%rsp), %xmm0
        movups 0x10(%rsp), %xmm1
        movups 0x20(%rsp), %xmm2
        movups 0x30(%rsp), %xmm3
        movups 0x40(%rsp), %xmm4
        movups 0x50(%rsp), %xmm5
        movups 0x60(%rsp), %xmm6
        movups 0x70(%rsp), %xmm7
        add    $0x80, %rsp
        .cfi_restore_state
        jmp    .Lfp_restored

        .hidden jl_runtime_resolve_fp_avx
        .globl  jl_runtime_resolve_fp_avx
jl_runtime_resolve_fp_avx:
        vorpd   %ymm0, %ymm1, %ymm8
        vorpd   %ymm2, %ymm3, %ymm9
        vorpd   %ymm4, %ymm5, %ymm10
        vorpd   %ymm6, %ymm7, %ymm11
        vorpd   %ymm8, %ymm9, %ymm8
        vorpd   %ymm10, %ymm11, %ymm10
        vorpd   %ymm8, %ymm10, %ymm8
        vextracti128 $1, %ymm8, %xmm8
        vptest  %xmm8, %xmm8
        jnz     .Lfp_avx
        vzeroupper
        // fall through

.Lfp_sse_vex:
        .cfi_remember_state
        sub     $0x80, %rsp
        .cfi_adjust_cfa_offset 128
        vmovups %xmm0, (%rsp)
        vmovups %xmm1, 0x10(%rsp)
        vmovups %xmm2, 0x20(%rsp)
        vmovups %xmm3, 0x30(%rsp)
        vmovups %xmm4, 0x40(%rsp)
        vmovups %xmm5, 0x50(%rsp)
        vmovups %xmm6, 0x60(%rsp)
        vmovups %xmm7, 0x70(%rsp)

        mov    %r11, %rdi       // %r11 was a pointer to the function info
        call   jl_runtime_resolve_real
        mov    %rax, %r11       // Now %r11 is the result function pointer

        vmovups (%rsp), %xmm0
        vmovups 0x10(%rsp), %xmm1
        vmovups 0x20(%rsp), %xmm2
        vmovups 0x30(%rsp), %xmm3
        vmovups 0x40(%rsp), %xmm4
        vmovups 0x50(%rsp), %xmm5
        vmovups 0x60(%rsp), %xmm6
        vmovups 0x70(%rsp), %xmm7
        add     $0x80, %rsp
        .cfi_restore_state
        jmp     .Lfp_restored

.Lfp_avx:
        .cfi_remember_state
        sub     $0x100, %rsp
        .cfi_adjust_cfa_offset 256
        vmovups %ymm0, (%rsp)
        vmovups %ymm1, 0x20(%rsp)
        vmovups %ymm2, 0x40(%rsp)
        vmovups %ymm3, 0x60(%rsp)
        vmovups %ymm4, 0x80(%rsp)
        vmovups %ymm5, 0xa0(%rsp)
        vmovups %ymm6, 0xc0(%rsp)
        vmovups %ymm7, 0xe0(%rsp)

        mov    %r11, %rdi       // %r11 was a pointer to the function info
        call   jl_runtime_resolve_real
        mov    %rax, %r11       // Now %r11 is the result function pointer

        vmovups (%rsp), %ymm0
        vmovups 0x20(%rsp), %ymm1
        vmovups 0x40(%rsp), %ymm2
        vmovups 0x60(%rsp), %ymm3
        vmovups 0x80(%rsp), %ymm4
        vmovups 0xa0(%rsp), %ymm5
        vmovups 0xc0(%rsp), %ymm6
        vmovups 0xe0(%rsp), %ymm7
        add     $0x100, %rsp
        .cfi_restore_state
        jmp     .Lfp_restored

        .hidden jl_runtime_resolve_fp_avx512_xg1
        .globl  jl_runtime_resolve_fp_avx512_xg1
jl_runtime_resolve_fp_avx512_xg1:
        mov     $0x1, %ecx
        xgetbv
        // 0x40 is the V512 bit, 0x4 is the YMM bit
        and     $0x44, %ax
        cmp     $0x4, %ax // `>` -> ZMM in use, `==` -> YMM in use
        je      .Lfp_avx
        jng     .Lfp_sse_vex
        // fall through

        .hidden jl_runtime_resolve_fp_avx512
        .globl  jl_runtime_resolve_fp_avx512
jl_runtime_resolve_fp_avx512:
        .cfi_remember_state
        sub       $0x200, %rsp
        .cfi_adjust_cfa_offset 512
        vmovdqu64 %zmm0, (%rsp)
        vmovdqu64 %zmm1, 0x40(%rsp)
        vmovdqu64 %zmm2, 0x80(%rsp)
        vmovdqu64 %zmm3, 0xc0(%rsp)
        vmovdqu64 %zmm4, 0x100(%rsp)
        vmovdqu64 %zmm5, 0x140(%rsp)
        vmovdqu64 %zmm6, 0x180(%rsp)
        vmovdqu64 %zmm7, 0x1c0(%rsp)

        mov    %r11, %rdi       // %r11 was a pointer to the function info
        call   jl_runtime_resolve_real
        mov    %rax, %r11       // Now %r11 is the result function pointer

        vmovdqu64 (%rsp), %zmm0
        vmovdqu64 0x40(%rsp), %zmm1
        vmovdqu64 0x80(%rsp), %zmm2
        vmovdqu64 0xc0(%rsp), %zmm3
        vmovdqu64 0x100(%rsp), %zmm4
        vmovdqu64 0x140(%rsp), %zmm5
        vmovdqu64 0x180(%rsp), %zmm6
        vmovdqu64 0x1c0(%rsp), %zmm7
        add       $0x200, %rsp
        .cfi_restore_state
        // jmp       .Lfp_restored

.Lfp_restored:
        // Restore MPX bounds registers
#ifdef JULIA_HAS_MPX_SUPPORT
        bndmov 0x40(%rsp), %bnd0
        bndmov 0x50(%rsp), %bnd1
        bndmov 0x60(%rsp), %bnd2
        bndmov 0x70(%rsp), %bnd3
#else
        .byte 0x66, 0x0f, 0x1a, 0x44, 0x24, 0x40
        .byte 0x66, 0x0f, 0x1a, 0x4c, 0x24, 0x50
        .byte 0x66, 0x0f, 0x1a, 0x54, 0x24, 0x60
        .byte 0x66, 0x0f, 0x1a, 0x5c, 0x24, 0x70
#endif

        // Restore integer registers
        mov    (%rsp), %r9
        mov    0x8(%rsp), %r8
        mov    0x10(%rsp), %rdx
        mov    0x18(%rsp), %rcx
        mov    0x20(%rsp), %rsi
        mov    0x28(%rsp), %rdi
        mov    0x30(%rsp), %rax
        add    $0x88, %rsp
        .cfi_adjust_cfa_offset -136
#ifndef JULIA_HAS_MPX_SUPPORT
        .byte 0xf2
        jmp *%r11
#else
        bnd jmp *%r11
#endif
        .cfi_endproc

        .size   jl_runtime_resolve, . - jl_runtime_resolve
