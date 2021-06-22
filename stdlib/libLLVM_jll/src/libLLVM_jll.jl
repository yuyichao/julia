# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/libLLVM_jll.jl

baremodule libLLVM_jll
using Base, Libdl, Zlib_jll, Zstd_jll

if !Sys.isapple()
    using CompilerSupportLibraries_jll
end

export libLLVM

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libLLVM_path = "/usr/lib/$(Base.libllvm_name).so"
const libLLVM = LazyLibrary(libLLVM_path)

function eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    Zlib_jll.eager_mode()
    # Zstd_jll.eager_mode() # Not lazy yet
    dlopen(libLLVM)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module libLLVM_jll
