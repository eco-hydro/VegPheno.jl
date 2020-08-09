using NetCDF

function ncread2(file::String, varname::String, bbox::Array{T, 1}) where {T <: Real}
    fid = NetCDF.open(file)
    ndim = length(fid.dim)
    lon = ncread(file, "lon")
    lat = ncread(file, "lat")

    Lon = (@. (lon >= bbox[1]) & (lon <= bbox[2])) |> findall
    Lat = (@. (lat >= bbox[3]) & (lat <= bbox[4])) |> findall

    start = [Lon[1], Lat[1]];
    count = [length(Lon), length(Lat)];
    if (ndim > 2)
        start = [start,  1];
        count = [count, -1];
    end
    # println(start, count)
    ncread(file, varname, start, count)
end

export ncread2
