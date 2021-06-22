# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/PCRE2_jll.jl
baremodule PCRE2_jll
using Base, Libdl

export libpcre2_8

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libpcre2_8_path = "/usr/lib/libpcre2-8.so"
const libpcre2_8 = LazyLibrary(libpcre2_8_path)

function eager_mode()
    dlopen(libpcre2_8)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module PCRE2_jll
