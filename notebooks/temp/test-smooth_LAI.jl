using NetCDF
using Glob
using BenchmarkTools
using Plots
gr()

# include("main_ylu.jl")

indir = "/mnt/n/MODIS/Terra_LAI_nc/"
files = glob("*2_3.nc", indir)

file = files[1]
bbox = get_bbox(file)

file_ylu = "/mnt/n/MODIS/Terra_LAI_ylu_2002-2019.nc"
@time ylu_A = ncread2(file_ylu, "LAI_amplitude", bbox)

ind = findall(ylu_A .>= 0.1)

@time data_A = resample(ylu_A);
perc = sum(data_A .> 0.1)/length(data_A) # 52.1%

# @time heatmap(spatial_array(data_A))

begin
    LAI = ncread(file, "LAI");
    QC  = ncread(file, "qcExtra");

    using Statistics
    @time LAI_sm = resample(LAI)
    @time QC_sm = resample(LAI)
    @benchmark dat = resample(LAI);
end
# ncinfo(file)

begin    
    LAI = NetCDF.open(files[1], "LAI")
    QC = NetCDF.open(files[1], "qcExtra")    
    I = ind[1]
    val = LAI[I[1], I[2], :] |> convert2int
    qc = QC[I[1], I[2], :] |> convert2int
end


begin
    lst_LAI = map(file -> NetCDF.open(file, "LAI"), files)
    lst_QC  = map(file -> NetCDF.open(file, "qcExtra"), files)
end

get_value(I, fids) = begin
    vals = map(x -> x[I[1], I[2], :], fids)
    vcat(vals...)
end
get_LAI(I) = get_value(I, lst_LAI)
get_QC(I) = get_value(I, lst_QC)

@time val = get_LAI(I) 
@time qc = get_QC(I)

using weight
w = zero(val) .+ 1

plot(val[1:46*6])

using whittaker
lambda = 2.0
val = val * 0.1
y2 = @time whit2(val, w, lambda)
# x2 = NetCDF.open(files[2], "LAI")

# dates = 

date = R"""
seq(as.Date("2010-01-01"), as.Date("2010-12-31"), by = "day")
"""

inds = 1:46*6
plot(val[inds])
plot!(y2[inds])
# dat[ dat .> 100] .= 100;
# heatmap(spatial_array(dat[:, :,20]))
# savefig("a.pdf")

using CSV

d_date = CSV.read("/mnt/n/MODIS/MODIS.jl/whittaker2/examples/LAI_dates.csv", comment = "#")
date = d_date.date[:]

plotly()
gr()

# Choose from 
# [:none, :auto, :circle, :rect, :star5, :diamond, :hexagon, :cross, :xcross, :utriangle, :dtriangle, :rtriangle, :ltriangle, :pentagon, :heptagon, :octagon, :star4, :star6, :star7, :star8, :vline, :hline, :+, :x].

plotly()
gr()

plot([1, 2, 3, 4], color = "grey60")


using RCall

R"""
dev.off()
"""

qc = convert2int(qc)
R"lw <- qc_FparLai($qc)"
QC_flag = R"lw$QC_flag"
level_names = R"levels(lw$QC_flag)" |> x -> rcopy.(String, x)

@time R"""
# library(phenofit)
l <- qc_FparLai($qc)
t = seq_along($val)
doy = seq(1, 366, 8)
# print(sprintf("%d%03d", 2010, doy))
date = as.Date(sprintf("%d%03d", 2010, doy), "%Y%j")
date = date[seq_along(t)]
print(date)

x = check_input(date, $val, w = l$w, QC_flag = l$QC_flag, 46)

# plot_input(x)
# latticeGrob::write_fig({
#     plot_input(x)
# }, "a.pdf", 10, 6, show = FALSE)
"""
R"""
y = $val
save(date, y, l, file = "debug.rda")
"""
l = @rget x
begin
    plot(val)
    plot!(l[:y])
    plot!(l[:y0])
end

# weight = convert.(Float32, w["w"])
# flag = w["QC_flag"]
# ind2 = CartesianIndex2Int(data_A, ind)

# # data2 = data_A[ind] # convert into column vector
# # data22 = data_A[ind2]
# @time ind = findall(ylu_A .<= 0.1)
# data2 = data_A[ind] # convert into column vector

# # tbl = Tables.table(ind2[:,:])
# # CSV.write("ind.csv", tbl)

