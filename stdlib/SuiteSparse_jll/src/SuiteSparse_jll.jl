# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/SuiteSparse_jll.jl
baremodule SuiteSparse_jll
using Base, Libdl
using libblastrampoline_jll
if !(Sys.isfreebsd() || Sys.isapple())
    using CompilerSupportLibraries_jll
end

export libamd, libbtf, libcamd, libccolamd, libcholmod, libcolamd, libklu, libldl, librbio, libspqr, libsuitesparseconfig, libumfpack

# These get calculated in __init__()
# Man I can't wait until these are automatically handled by an in-Base JLLWrappers clone.
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libsuitesparseconfig_path = "/usr/lib/libsuitesparseconfig.so"
const libsuitesparseconfig = LazyLibrary(libsuitesparseconfig_path)

const libldl_path = "/usr/lib/libldl.so"
const libldl = LazyLibrary(libldl_path)

const libbtf_path = "/usr/lib/libbtf.so"
const libbtf = LazyLibrary(libbtf_path)

const libcolamd_path = "/usr/lib/libcolamd.so"
const libcolamd = LazyLibrary(libcolamd_path)

const libamd_path = "/usr/lib/libamd.so"
const libamd = LazyLibrary(libamd_path)

const libcamd_path = "/usr/lib/libcamd.so"
const libcamd = LazyLibrary(libcamd_path)

const libccolamd_path = "/usr/lib/libccolamd.so"
const libccolamd = LazyLibrary(libccolamd_path)

const librbio_path = "/usr/lib/librbio.so"
const librbio = LazyLibrary(librbio_path)

const libcholmod_path = "/usr/lib/libcholmod.so"
const libcholmod = LazyLibrary(libcholmod_path)

const libklu_path = "/usr/lib/libklu.so"
const libklu = LazyLibrary(libklu_path)

const libspqr_path = "/usr/lib/libspqr.so"
const libspqr = LazyLibrary(libspqr_path)

const libumfpack_path = "/usr/lib/libumfpack.so"
const libumfpack = LazyLibrary(libumfpack_path)

function eager_mode()
    @static if @isdefined CompilerSupportLibraries_jll
        CompilerSupportLibraries_jll.eager_mode()
    end
    libblastrampoline_jll.eager_mode()

    dlopen(libamd)
    dlopen(libbtf)
    dlopen(libcamd)
    dlopen(libccolamd)
    dlopen(libcholmod)
    dlopen(libcolamd)
    dlopen(libklu)
    dlopen(libldl)
    dlopen(librbio)
    dlopen(libspqr)
    dlopen(libsuitesparseconfig)
    dlopen(libumfpack)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module SuiteSparse_jll
