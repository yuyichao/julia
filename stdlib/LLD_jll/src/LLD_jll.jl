# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/LLD_jll.jl

baremodule LLD_jll
using Base, Libdl

export lld

# These get calculated in __init__()
const PATH = Ref("/usr/bin")
const PATH_list = String["/usr/bin"]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"
const lld_path = "/usr/bin/lld"
if Sys.iswindows()
    const lld_exe = "lld.exe"
else
    const lld_exe = "lld"
end

if Sys.iswindows()
    const LIBPATH_env = "PATH"
    const LIBPATH_default = ""
    const pathsep = ';'
elseif Sys.isapple()
    const LIBPATH_env = "DYLD_FALLBACK_LIBRARY_PATH"
    const LIBPATH_default = "~/lib:/usr/local/lib:/lib:/usr/lib"
    const pathsep = ':'
else
    const LIBPATH_env = "LD_LIBRARY_PATH"
    const LIBPATH_default = ""
    const pathsep = ':'
end

function adjust_ENV!(env::Dict, PATH::String, LIBPATH::String, adjust_PATH::Bool, adjust_LIBPATH::Bool)
    return env
end

function lld(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    return f(lld_path)
end
function lld(; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    return `$lld_path`
end

function init_lld_path()
end

# JLLWrappers API compatibility shims.  Note that not all of these will really make sense.
# For instance, `find_artifact_dir()` won't actually be the artifact directory, because
# there isn't one.  It instead returns the overall Julia prefix.
is_available() = true
find_artifact_dir() = artifact_dir
dev_jll() = error("stdlib JLLs cannot be dev'ed")
best_wrapper = nothing

end  # module libLLD_jll
