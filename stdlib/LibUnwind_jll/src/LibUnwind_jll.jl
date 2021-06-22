# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/LibUnwind_jll.jl

baremodule LibUnwind_jll
using Base, Libdl
using Zlib_jll
if !Sys.isfreebsd()
    using CompilerSupportLibraries_jll
end

export libunwind

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libunwind_path = "/usr/lib/libunwind.so"
const libunwind = LazyLibrary(libunwind_path)

function eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    Zlib_jll.eager_mode()
    dlopen(libunwind)
end
is_available() = @static(Sys.islinux() || Sys.isfreebsd()) ? true : false

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module LibUnwind_jll
