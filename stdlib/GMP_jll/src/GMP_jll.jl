# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/GMP_jll.jl
baremodule GMP_jll
using Base, Libdl
if !Sys.isapple()
    using CompilerSupportLibraries_jll
end

export libgmp, libgmpxx

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libgmp_path = "/usr/lib/libgmp.so"
const libgmp = LazyLibrary(libgmp_path)

const libgmpxx_path = "/usr/lib/libgmpxx.so"
const libgmpxx = LazyLibrary(libgmpxx_path)

function eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    dlopen(libgmp)
    dlopen(libgmpxx)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module GMP_jll
