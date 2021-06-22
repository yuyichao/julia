# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/OpenLibm_jll.jl
baremodule OpenLibm_jll
using Base, Libdl
if Sys.iswindows()
    using CompilerSupportLibraries_jll
end

export libopenlibm

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libopenlibm_path = "/usr/lib/libopenlibm.so"
const libopenlibm = LazyLibrary(libopenlibm_path)

function eager_mode()
    dlopen(libopenlibm)
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
end
is_available() = true

end  # module OpenLibm_jll
