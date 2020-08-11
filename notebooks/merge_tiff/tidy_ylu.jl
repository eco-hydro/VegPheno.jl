using ArchGDAL
using NetCDF
# include("MODIS.jl")
# include("main_ylu.jl")

infile = "/mnt/n/MODIS/Terra_LAI_ylu_2002-2019.tif"
# infile = "/mnt/c/Program Files/MATLAB/R2018b/toolbox/images/imdata/AT3_1m4_07.tif"
# infile = "/mnt/c/Users/kongdd/Google 云端硬盘/Data/PML/2002-07-12.tif"

# r = readGDAL(infile);
# @time diff =  r[:,:,2] .- r[:,:,1]
# ncwrite_ylu("/mnt/n/MODIS/Terra_LAI_ylu_2002-2019_v2.nc")

outfile ="/mnt/n/MODIS/Terra_LAI_ylu_2002-2019_v2.nc"
file = outfile

# @time r = NetCDF.open(outfile, "LAI_min")
# @time r2 = ncread(outfile, "LAI_min");
# size(r)
# @time A = read_tiff(infile, 1);

### test equivalent parameter of `...`methods(ArchGDAL.read)

# read(dataset::ArchGDAL.AbstractDataset, i::Integer, xoffset::Integer, yoffset::Integer, xsize::Integer, ysize::Integer)

bbox = [-180, 180, -60, 90]
bbox = [70, 140, 15, 55]
@time data = ncread2(file, "LAI_min", bbox);
@time out = resample(data, 10)

@time heatmap(spatial_array(out))
# lon, lat = get_coord(bbox, 1);
# split raster into multiple nc files
using Plots
gr()
# @time heatmap(r2)

@time heatmap(flipud(transpose(data)))
savefig("cont.png")

# histogram(randn(10000))
size(data)
