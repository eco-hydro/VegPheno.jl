function match2(x, y)
    n = length(x)
    I_x = ones(Int, n)
    I_y = ones(Int, n)
    for i in 1:n
        I_y[i] = findfirst(x[i] .== y)
        I_x[i] = findfirst(y[i] .== x)
    end
    I_x, I_y
end


function list_dir(indir)
    filter(x -> isdir(joinpath(indir, x)), readdir(indir, join = true))
end

function str_extract(x, pattern = r"\d{4}_\d{1}_\d") 
    if typeof(x) == String; x = [x]; end
    str = match.(pattern, x)
    str = map(x -> x.match, str)
end

function split(list, names) 
    grps = unique(names)
    map(grp -> Pair(grp, list[names .== grp]), grps)
end


function CartesianIndex2Int(x, ind)
    I = LinearIndices(x)
    # I = 1:prod(size(x))
    I[ind]
end


export match2, split, str_extract, list_dir, CartesianIndex2Int
