# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/LibCURL_jll.jl

baremodule LibCURL_jll
using Base, Libdl, nghttp2_jll, LibSSH2_jll, Zlib_jll, Zstd_jll
if !Sys.iswindows()
    using OpenSSL_jll
end
if Sys.iswindows() && Sys.WORD_SIZE == 32
    using CompilerSupportLibraries_jll
end

export libcurl

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libcurl_path = "/usr/lib/libcurl.so"
const libcurl = LazyLibrary(libcurl_path)

function eager_mode()
    Zlib_jll.eager_mode()
    Zstd_jll.eager_mode()
    nghttp2_jll.eager_mode()
    LibSSH2_jll.eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    @static if @isdefined OpenSSL_jll
        OpenSSL_jll.eager_mode()
    end
    dlopen(libcurl)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module LibCURL_jll
