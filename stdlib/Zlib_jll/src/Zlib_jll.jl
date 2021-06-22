# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/Zlib_jll.jl
baremodule Zlib_jll
using Base, Libdl

export libz

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libz_path = "/usr/lib/libz.so"
const libz = LazyLibrary(libz_path)

function eager_mode()
    dlopen(libz)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module Zlib_jll
