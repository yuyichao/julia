# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/Zstd_jll.j:
#
baremodule Zstd_jll
using Base, Libdl
if Sys.iswindows() && Sys.WORD_SIZE == 32
    using CompilerSupportLibraries_jll
end

export libzstd, zstd, zstdmt

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libzstd_path = "/usr/lib/libzstd.so"
const libzstd = LazyLibrary(libzstd_path)
const zstd_path = "/usr/bin/zstd"
const zstdmt_path = "/usr/bin/zstdmt"

if Sys.iswindows()
    const zstd_exe = "zstd.exe"
    const zstdmt_exe = "zstdmt.exe"
else
    const zstd_exe = "zstd"
    const zstdmt_exe = "zstdmt"
end

if Sys.iswindows()
    const pathsep = ';'
elseif Sys.isapple()
    const pathsep = ':'
else
    const pathsep = ':'
end

if Sys.iswindows()
function adjust_ENV(cmd::Cmd)
    dllPATH = Sys.BINDIR
    oldPATH = get(ENV, "PATH", "")
    newPATH = isempty(oldPATH) ? dllPATH : "$dllPATH$pathsep$oldPATH"
    return addenv(cmd, "PATH"=>newPATH)
end
else
adjust_ENV(cmd::Cmd) = cmd
end

function adjust_ENV()
    return ()
end

function zstd(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true) # deprecated, for compat only
    f(zstd())
end
function zstdmt(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true) # deprecated, for compat only
    f(zstdmt())
end
zstd() = `/usr/bin/zstd`
zstdmt() = `/usr/bin/zstdmt`

# Function to eagerly dlopen our library and thus resolve all dependencies
function eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    dlopen(libzstd)
end

is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module Zstd_jll
