// This file is a part of Julia. License is MIT: https://julialang.org/license
//
// This is the runtime resolve callback for aarch64 arch following AAPCS64.
//
// We can use any caller saved registers (r9 - r15)
// as well as the two intra-procedure-call temporary register (r16 and r17)

        .text
        .hidden jl_runtime_resolve
        .globl  jl_runtime_resolve
        .type   jl_runtime_resolve, #function
jl_runtime_resolve:
        .cfi_startproc
        stp     x29, x30, [sp, #-240]!
        .cfi_def_cfa_offset 240
        .cfi_offset 29, -240
        .cfi_offset 30, -232
        // Save integer registers in 0x10 to 0x60
        stp     x0, x1, [sp, #0x10]
        stp     x2, x3, [sp, #0x20]
        stp     x4, x5, [sp, #0x30]
        stp     x6, x7, [sp, #0x40]
        stp     x8, x9, [sp, #0x50] // x9 is not necessary and is just for alignment

        // Save vector registers in 0x60 to 0xe0
        stp     q0, q1, [sp, #0x60]
        stp     q2, q3, [sp, #0x80]
        stp     q4, q5, [sp, #0xa0]
        stp     q6, q7, [sp, #0xc0]

        mov     x0, x16         // x16 was a pointer to the function info
        bl      jl_runtime_resolve_real
        mov     x16, x0         // Now x16 is the result function pointer

        // Restore vector registers
        ldp     q0, q1, [sp, #0x60]
        ldp     q2, q3, [sp, #0x80]
        ldp     q4, q5, [sp, #0xa0]
        ldp     q6, q7, [sp, #0xc0]

        // Restore integer registers
        ldp     x0, x1, [sp, #0x10]
        ldp     x2, x3, [sp, #0x20]
        ldp     x4, x5, [sp, #0x30]
        ldp     x6, x7, [sp, #0x40]
        ldp     x8, x9, [sp, #0x50]

        ldp     x29, x30, [sp], 240
        .cfi_adjust_cfa_offset -240
        br      x16
        .cfi_endproc

        .size   jl_runtime_resolve, . - jl_runtime_resolve
