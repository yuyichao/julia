# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/LLVMLibUnwind_jll.jl

baremodule LLVMLibUnwind_jll
using Base, Libdl

export llvmlibunwind

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const llvmlibunwind_path = "/usr/lib/libunwind.so"
const llvmlibunwind = LazyLibrary(llvmlibunwind_path)

function eager_mode()
    dlopen(llvmlibunwind)
end
is_available() = @static Sys.isapple() ? true : false

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module LLVMLibUnwind_jll
