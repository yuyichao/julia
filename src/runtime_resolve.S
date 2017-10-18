// This file is a part of Julia. License is MIT: https://julialang.org/license

#include "runtime_resolve.h"

#if defined(_CPU_X86_64_)
#  ifndef _OS_WINDOWS_
#    include "runtime_resolve-unix-x86_64.S"
#  endif
#elif defined(_CPU_AARCH64_)
#  include "runtime_resolve-aarch64.S"
#elif defined(_CPU_ARM_)
#  include "runtime_resolve-aarch32.S"
#endif
