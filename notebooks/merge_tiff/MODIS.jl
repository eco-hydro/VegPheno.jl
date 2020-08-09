using ArchGDAL; const AG = ArchGDAL
using GDAL
using Glob
using NetCDF

function nc_write(val_LAI, val_qcExtra, lons::Array{Float64,1}, lats::Array{Float64,1}, 
    ntime::Integer, outfile = "Terra_LAI.nc", compress = 1)
    
    lonatts = Dict("longname" => "Longitude", "units" => "degrees east")
    latatts = Dict("longname" => "Latitude", "units" => "degrees north")
    timatts = Dict("longname" => "Time", "units" => "hours since 01-01-2000 00:00:00")

    # outfile = "ex-03.nc"
    if isfile(outfile); return; end

    vtype = 7 # NC_UBYTE
    # -1, 49s, 7.6G
    #  1, 23s, 195M
    compress = 1 # 
    nccreate(
        outfile,
        "LAI",
        "lon", lons, lonatts,
        "lat", lats, latatts,
        "time", 1:ntime/2, #timatts,
        # atts = varatts,
        compress = compress, t = vtype)
    nccreate(
        outfile,
        "qcExtra",
        "lon", "lat", "time", 
        # timatts,
        # atts = varatts,
        compress = compress, t = vtype)
    # size(val_LAI)
    @time ncwrite(val_LAI    , outfile, "LAI")
    @time ncwrite(val_qcExtra, outfile, "qcExtra")   
end

# params
# i: pair Dict
function tiff2nc(i, outdir)
    # i = lst_files[1]
    # for i in lst_files
    files_i = i
    prefix = i[1]

    outfile = outdir * "MOD15A2H-raw-LAI_240deg_global_" * prefix * ".nc"
    println(outfile)
    if (isfile(outfile)); return; end
    # typeof(files), typeof(files_i)
    # files_i[1]
    chunks = str_extract(files_i[2], r"\d{4}_\d{1}_\d-\d*") # -\d*
    lst_files2 = split(files_i[2], chunks)

    # print(lst_files2)
    ## get chunks
    ranges1 = map(x -> gdalinfo(x)["range"], lst_files2[1][2])
    ranges2 = map(x -> gdalinfo(x)["range"], lst_files2[2][2])
    #println(ranges1)
    # ymin, ymax
    xmin = ranges1[1][1]
    xmax = ranges1[end][2]
    ymax = ranges1[1][4]
    ymin = round(ranges2[1][3])

    ymax1 = ranges1[1][4]
    ymax2 = ranges2[1][4]

    info = gdalinfo(files_i[2][1])
    dy    = 1.0/240
    ntime = info["ntime"]
    lats = reverse(ymin+dy/2 : dy : ymax)
    lons = xmin+dy/2 : dy : xmax
    println((xmin, xmax, ymin, ymax))

    # length(lons), length(lats), ntime
    res = []
    for j in lst_files2
        files = j[2]
        temp = readGDAL(files) # , 1:2:ntime
        push!(res, temp)
    end
    res = hcat(res...)
    
    val_LAI = res[:, :, 1:2:ntime];
    val_qcExtra = res[:, :, 2:2:ntime];
    # size(val_LAI), size(val_qcExtra)
    nc_write(val_LAI, val_qcExtra, lons, lats, ntime, outfile, 1)
end
