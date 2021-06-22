# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/p7zip_jll.jl
baremodule p7zip_jll
using Base

export p7zip

# These get calculated in __init__()
const PATH = Ref("/usr/bin")
artifact_dir::String = "/usr"
const p7zip_path = "/usr/bin/7z"
if Sys.iswindows()
    const p7zip_exe = "7z.exe"
else
    const p7zip_exe = "7z"
end

if Sys.iswindows()
    const pathsep = ';'
elseif Sys.isapple()
    const pathsep = ':'
else
    const pathsep = ':'
end

function adjust_ENV()
    return ()
end

function p7zip(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true) # deprecated, for compat only
    return f(p7zip())
end
# the 7z.exe we ship has no dependencies, so it needs no PATH adjustment
p7zip(; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true) = `$p7zip_path`

function init_p7zip_path()
end

# JLLWrappers API compatibility shims.  Note that not all of these will really make sense.
# For instance, `find_artifact_dir()` won't actually be the artifact directory, because
# there isn't one.  It instead returns the overall Julia prefix.
is_available() = true
find_artifact_dir() = artifact_dir
dev_jll() = error("stdlib JLLs cannot be dev'ed")
best_wrapper = nothing

end  # module p7zip_jll
