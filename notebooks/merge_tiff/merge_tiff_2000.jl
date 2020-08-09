include("MODIS.jl")

# str_extractfiles_i[1]
outdir = "/mnt/e/github/julia/nc/"

indir ="/mnt/n/MODIS/Terra_LAI/2001/"
files = glob("*.tif", indir)
file  = files[1]

strs  = str_extract(files)
lst_files = split(files, strs)

files_i = lst_files[1][2]

for files_raw in lst_files
    prefix = files_raw[1]
    files_i = files_raw[2]
    outfile = outdir * "MOD15A2H-raw-LAI_240deg_global_" * prefix * ".nc"
    if (isfile(outfile))
        continue
    end
    
    ranges = map(x -> get_range(x)["range"], files_i)
    print(ranges)

    info  = get_range(files_i[1])
    dy    = 1.0/240
    ntime = info["ntime"]
    lons  = collect(ranges[1][1] + dy/2 : dy: ranges[4][2]);
    lats  = info["lat"]
    
    # println(files_raw[1])
    println((length(lons), length(lats), ntime, outfile))
    
    break
    @time val_LAI     = read_tiff(files_i, 1:2:ntime)
    @time val_qcExtra = read_tiff(files_i, 2:2:ntime)
    # nc_write(val_LAI, val_qcExtra, lons, lats, outfile, 1)
end
