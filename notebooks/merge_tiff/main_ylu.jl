
function ncwrite_ylu(outfile)
    lonatts = Dict("longname" => "Longitude", "units" => "degrees east")
    latatts = Dict("longname" => "Latitude", "units" => "degrees north")
    timatts = Dict("longname" => "Time", "units" => "hours since 1970-01-01 00:00:00")

    # outfile = "ex-03.nc"
    if isfile(outfile); rm(outfile); end #return;

    bbox = [-180, 180, -60, 90]
    cellsize = 1/240
    lon, lat = get_coord(bbox, cellsize)
    
    chunksize = (Cint(10), Cint(10)) .* Cint(240)
    
    # vtype = 7 # NC_UBYTE
    vtype = NC_FLOAT
    compress = 1 # 
    nccreate(outfile,
        "LAI_min",
        "lon", lon, lonatts, 
        "lat", lat, latatts,
        compress = compress, t = vtype, chunksize = chunksize)
    nccreate(outfile,
        "LAI_max",
        "lon", "lat",
        compress = compress, t = vtype, chunksize = chunksize)
    nccreate(outfile,
        "LAI_amplitude",
        "lon", "lat",
        compress = compress, t = vtype, chunksize = chunksize)
    # size(val_LAI)
    @time ncwrite(r[:,:,1], outfile, "LAI_min")
    ncwrite(r[:,:,2], outfile, "LAI_max")
    ncwrite(diff    , outfile, "LAI_amplitude")
end
