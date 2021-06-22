# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/OpenSSL_jll.jl

baremodule OpenSSL_jll
using Base, Libdl, Base.BinaryPlatforms

export libcrypto, libssl

# These get calculated in __init__()
const PATH = Ref("")
const PATH_list = String[]
const LIBPATH = Ref("/usr/lib")
const LIBPATH_list = String["/usr/lib"]
artifact_dir::String = "/usr"

const libcrypto_path = "/usr/lib/libcrypto.so"
const libcrypto = LazyLibrary(libcrypto_path)

const libssl_path = "/usr/lib/libssl.so"
const libssl = LazyLibrary(libssl_path)

function eager_mode()
    dlopen(libcrypto)
    dlopen(libssl)
end
is_available() = true

if Base.generating_output()
    precompile(eager_mode, ())
    precompile(is_available, ())
end

end  # module OpenSSL_jll
