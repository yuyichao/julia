# Write the sys source cache in format readable by Base._read_dependency_src
cachefile = ARGS[1]
open(cachefile, "w") do io
    for (_, filename) in Base._included_files
        if isfile(get(ENV, "JL_MAKEPKG_SRCDIR", "") * "/" * filename)
            src = read(get(ENV, "JL_MAKEPKG_SRCDIR", "") * "/" * filename, String)
        elseif isfile(filename)
            src = read(filename, String)
        end
        write(io, Int32(sizeof(filename)))
        write(io, filename)
        write(io, UInt64(sizeof(src)))
        write(io, src)
    end
    write(io, Int32(0))
end
