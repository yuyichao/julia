# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/LibSSH2_jll.jl

baremodule LibSSH2_jll
using Base, Libdl
if Sys.isfreebsd() || Sys.isapple()
    using Zlib_jll
end
if Sys.iswindows() && Sys.WORD_SIZE == 32
    using CompilerSupportLibraries_jll
end
if !Sys.iswindows()
    using OpenSSL_jll
end

export libssh2

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libssh2_path = "/usr/lib/libssh2.so"
const libssh2 = LazyLibrary(libssh2_path)

function eager_mode()
    @static if @isdefined Zlib_jll
        Zlib_jll.eager_mode()
    end
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    @static if @isdefined OpenSSL_jll
        OpenSSL_jll.eager_mode()
    end
    dlopen(libssh2)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module LibSSH2_jll
