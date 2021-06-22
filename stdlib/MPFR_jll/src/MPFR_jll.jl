# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/MPFR_jll.jl
baremodule MPFR_jll
using Base, Libdl, GMP_jll
if Sys.iswindows()
    using CompilerSupportLibraries_jll
end

export libmpfr

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libmpfr_path = "/usr/lib/libmpfr.so"
const libmpfr = LazyLibrary(libmpfr_path)

function eager_mode()
    GMP_jll.eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    dlopen(libmpfr)
end
is_available() = true

end  # module MPFR_jll
