# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/CompilerSupportLibraries_jll.jl

baremodule CompilerSupportLibraries_jll
using Base, Libdl, Base.BinaryPlatforms

export libgfortran, libstdcxx, libgomp, libatomic, libgcc_s

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libatomic_path = "/usr/lib/libatomic.so"
const libatomic = LazyLibrary(libatomic_path)
if Sys.iswindows() || Sys.isapple() || arch(HostPlatform()) ∈ ("x86_64", "i686")
    const libquadmath_path = "/usr/lib/libquadmath.so"
    const libquadmath = LazyLibrary(libquadmath_path)
end
const libgcc_s_path = "/usr/lib/libgcc_s.so.1"
const libgcc_s = LazyLibrary(libgcc_s_path)
const libgfortran_path = "/usr/lib/libgfortran.so"
const libgfortran = LazyLibrary(libgfortran_path)
const libstdcxx_path = "/usr/lib/libstd++.so"
const libstdcxx = LazyLibrary(libstdcxx_path)
const libgomp_path = "/usr/lib/libgomp.so"
const libgomp = LazyLibrary(libgomp_path)

# Conform to LazyJLLWrappers API
function eager_mode()
    if @isdefined(libatomic)
        dlopen(libatomic)
    end
    dlopen(libgcc_s)
    dlopen(libgomp)
    if @isdefined libquadmath
        dlopen(libquadmath)
    end
    dlopen(libgfortran)
    dlopen(libstdcxx)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module CompilerSupportLibraries_jll
