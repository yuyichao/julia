# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/nghttp2_jll.jl
baremodule nghttp2_jll
using Base, Libdl
if Sys.iswindows() && Sys.WORD_SIZE == 32
    using CompilerSupportLibraries_jll
end

export libnghttp2

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libnghttp2_path = "/usr/lib/libnghttp2.so"
const libnghttp2 = LazyLibrary(libnghttp2_path)

function eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    dlopen(libnghttp2)
end
is_available() = true

end  # module nghttp2_jll
