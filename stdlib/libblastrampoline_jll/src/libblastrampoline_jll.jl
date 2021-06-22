# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/libblastrampoline_jll.jl

baremodule libblastrampoline_jll
using Base, Libdl

export libblastrampoline

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

# Because LBT needs to have a weak-dependence on OpenBLAS (or any other BLAS)
# we must manually construct a list of which modules and libraries we're going
# to be using with it, as well as the on load callbacks they may or may not need.
const on_load_callbacks::Vector{Function} = Function[]
const eager_mode_modules::Vector{Module} = Module[]
function libblastrampoline_on_load_callback()
    for callback = on_load_callbacks
        callback()
    end
end

function add_dependency!(mod::Module, lib::LazyLibrary, on_load_callback::Function = () -> nothing)
    Libdl.add_dependency!(libblastrampoline, lib)
    push!(eager_mode_modules, mod)
    push!(on_load_callbacks, on_load_callback)
end

const libblastrampoline_path = "/usr/lib/libblastrampoline.so"
const libblastrampoline = LazyLibrary(
    libblastrampoline_path,
    dependencies = LazyLibrary[],
    on_load_callback = libblastrampoline_on_load_callback
)

function eager_mode()
    for mod in eager_mode_modules
        mod.eager_mode()
    end
    dlopen(libblastrampoline)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module libblastrampoline_jll
