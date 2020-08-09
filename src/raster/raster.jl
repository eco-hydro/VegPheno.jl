"""
get_coord(bbox, cellsize)

#return
tuple of (lon, lat)
- lon: vector with the length of nlon
- lat: vector with the length of nlat
"""
function get_coord(bbox::Array{T,1}, cellsize::T2) where {T <: Real, T2 <: Real}
    lon_min = bbox[1]
    lon_max = bbox[2]
    lat_min = bbox[3]
    lat_max = bbox[4]

    lon = lon_min + cellsize/2 : cellsize : lon_max
    lat = reverse(lat_min + cellsize/2 : cellsize : lat_max)
    lon, lat # return
end

"""
get detailed GDAL information

## return
- `file`     : 
- `range`    : [lon_min, lon_max, lat_min, lat_max]
- `cellsize` : [cellsize_x, cellsize_y]
- `lon`      : longitudes with the length of nlon
- `lat`      : latitudes with the length of nlat
- `dim`      : [width, height]
- `ntime`    : length of time
"""
function gdalinfo(file) 
    ds = ArchGDAL.read(file)
    gt = AG.getgeotransform(ds)
    # band = AG.getband(ds, 1)
    w, h = AG.width(ds), AG.height(ds)
    dx, dy = gt[2], -gt[end]
    x0 = gt[1] #+ dx/2
    x1 = x0 + w* dx
    y1 = gt[4] #- dy/2
    y0 = y1 - h*dy
    range = [x0, x1, y0, y1]
    
    lon = x0 + dx/2 : dx: x1
    lat = reverse(y0 + dy/2 : dy: y1)
    ntime = ArchGDAL.nraster(ds)
    
    Dict(
        "file"     => basename(file),
        "range"    => range, 
        "cellsize" => [dx, dy], 
        "lon"      => lon,
        "lat"      => lat,
        "dim"      => [w, h],
        "ntime"    => ntime)
end


function get_range(ncfile::String)
    lat = ncread(ncfile, "lat")
    lon = ncread(ncfile, "lon")
    cellsize_x = abs(lon[2] - lon[1])
    cellsize_y = abs(lat[2] - lat[1])
    
    [minimum(lon) - cellsize_x/2, maximum(lon) + cellsize_x/2,
        minimum(lat) - cellsize_y/2, maximum(lat) + cellsize_y/2]
end


function readGDAL(file::String, options...)
    ArchGDAL.read(file) do dataset
        ArchGDAL.read(dataset, options...)
    end
end

# read multiple tiff files and cbind
function readGDAL(files::Array{String,1}, options)
    # bands = collect(bands)
    bands = collect(Int32, bands)
    res = map(file -> readGDAL(file, options...), files)
    vcat(res...)
end

export get_coord, gdalinfo, readGDAL, get_range
