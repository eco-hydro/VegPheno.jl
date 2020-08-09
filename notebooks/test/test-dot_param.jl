
function show2(arg...)
    println(arg)
    println(1, arg...)
end

function show_param2(x, y, z...)
    println(z)
    println("x=$x, y=$y, z=$z")
    # println(z...)
    show2(z...)
end

function hello(file::String, options...)
    # ArchGDAL.read(file) do dataset
        # if bands === nothing
            # println(options...)
            show_param2(options...)
            # show_param(file, options)
            # ArchGDAL.read(dataset, options...)
        # else
            # ArchGDAL.read(dataset, bands)
        # end
    # end
end

