// This file is a part of Julia. License is MIT: https://julialang.org/license

#include "platform.h"

#ifdef __cplusplus
extern "C" {
#endif

// The function prototypes here are not at all correct.
// In fact, these functions doesn't have a valid prototype since they don't at all follow
// the platform calling convention.
// They are listed here so that the C code can refer to their addresses
// and should not be called directly.
#ifndef JL_IN_ASM
void jl_runtime_resolve(void);
#  if defined(_CPU_X86_64_)
extern void (*jl_runtime_resolve_fp)(void);
void jl_runtime_resolve_fp_sse(void);
void jl_runtime_resolve_fp_avx(void);
void jl_runtime_resolve_fp_avx512_xg1(void);
void jl_runtime_resolve_fp_avx512(void);
#  endif
#endif

#ifdef __cplusplus
}
#endif
