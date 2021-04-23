using phenofit
using DataFrames, CSV
# pyplot()
# 测试河南老家站点，2016-2018年，结果与GEE结果完全一致
# Dongdong Kong, 2021-05-14
# ------------------------------------------------------------------------------
# https://code.earthengine.google.com/?scriptPath=users%2Fkongdd%2Fgee_PML2%3Atests%2FWhittaker%2Ftest-wFUN_global%20LAI.js
# var coor = [115.24519349785182, 33.30525487954337]; //home
# var point = ee.Geometry.Point(coor);

df = DataFrame(CSV.File("scripts/data.csv"))

# include("dat_GEE.jl")
begin
    y = df[:,1]*1.0
    w = df[:,2]
    outfile = "test-GEE2.pdf"
    # @run 
    r = smooth_whit_GEE(y, w, 
        outfile = outfile,
        λ = 3.2087777335224645*10, 
        adj_factor = 10,
        is_plot = true,
        niters = 2, 
        trs_high = 0.7, trs_low = 0.4, trs_bg = 0.2, 
        step = 0.3)';
    # show_pdf(outfile)
    # r = floor.(r)
end
# run("ls")
# show_pdf(outfile)
