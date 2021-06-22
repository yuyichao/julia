# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/LibGit2_jll.jl

baremodule LibGit2_jll
using Base, Libdl, LibSSH2_jll, PCRE2_jll, Zlib_jll
if !(Sys.iswindows() || Sys.isapple())
    using OpenSSL_jll
end
if Sys.iswindows() && Sys.WORD_SIZE == 32
    using CompilerSupportLibraries_jll
end

export libgit2

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libgit2_path = "/usr/lib/libgit2.so"
const libgit2 = LazyLibrary(libgit2_path)

function eager_mode()
    LibSSH2_jll.eager_mode()
    @static if @isdefined OpenSSL_jll
        OpenSSL_jll.eager_mode()
    end
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    dlopen(libgit2)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module LibGit2_jll
