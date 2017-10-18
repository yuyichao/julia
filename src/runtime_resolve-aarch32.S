// This file is a part of Julia. License is MIT: https://julialang.org/license
//
// This is the runtime resolve callback for aarch64 arch following AAPCS64.
//
// We can use the intra-procedure-call temporary register (r12)

        .text
        .hidden jl_runtime_resolve
        .globl  jl_runtime_resolve
        .type   jl_runtime_resolve, #function
        .arm
        .fpu vfp
jl_runtime_resolve:
        .fnstart
        push     {r0-r6,lr} // Make sure the stack is still aligned...
        .save    {r0-r6, lr}
        vpush.64 {d0-d7}
        .vsave   {d0-d7}

        mov      r0, r12
        bl       jl_runtime_resolve_real
        mov      r12, r0

        vpop.64  {d0-d7}
        .pad     #-64
        pop      {r0-r6,lr}
        .pad     #-32
        bx       r12
        .fnend

        .size   jl_runtime_resolve, . - jl_runtime_resolve
