
# write_fig2(ps, "a.pdf")
# write_pdf(ps, "b.pdf")
# # w = zero(val) .+ 1
# plot(val[1:46*6])

# using whittaker
# lambda = 2.0
# val = val * 0.1
# y2 = @time whit2(val, w, lambda)
# # x2 = NetCDF.open(files[2], "LAI")

# # dates = 
# date = R"""
# seq(as.Date("2010-01-01"), as.Date("2010-12-31"), by = "day")
# """

# inds = 1:46*6
# plot(val[inds])
# plot!(y2[inds])
# # dat[ dat .> 100] .= 100;
# # heatmap(spatial_array(dat[:, :,20]))
# # savefig("a.pdf")

# plotly()
# gr()

# # Choose from 
# # [:none, :auto, :circle, :rect, :star5, :diamond, :hexagon, :cross, :xcross, :utriangle, :dtriangle, :rtriangle, :ltriangle, :pentagon, :heptagon, :octagon, :star4, :star6, :star7, :star8, :vline, :hline, :+, :x].
# plotly()
# gr()
# plot([1, 2, 3, 4], color = "grey60")

# using RCall
# R"""
# dev.off()
# """

# qc = convert2int(qc)

# @time R"""
# # library(phenofit)
# l <- qc_FparLai($qc)
# t = seq_along($val)
# doy = seq(1, 366, 8)
# # print(sprintf("%d%03d", 2010, doy))
# date = as.Date(sprintf("%d%03d", 2010, doy), "%Y%j")
# date = date[seq_along(t)]
# print(date)

# x = check_input(date, $val, w = l$w, QC_flag = l$QC_flag, 46)

# # plot_input(x)
# # latticeGrob::write_fig({
# #     plot_input(x)
# # }, "a.pdf", 10, 6, show = FALSE)
# """
# R"""
# y = $val
# save(date, y, l, file = "debug.rda")
# """
# l = @rget x
# begin
#     plot(val)
#     plot!(l[:y])
#     plot!(l[:y0])
# end

# # weight = convert.(Float32, w["w"])
# # flag = w["QC_flag"]
# # ind2 = CartesianIndex2Int(data_A, ind)

# # # data2 = data_A[ind] # convert into column vector
# # # data22 = data_A[ind2]
# # @time ind = findall(ylu_A .<= 0.1)
# # data2 = data_A[ind] # convert into column vector

# # # tbl = Tables.table(ind2[:,:])
# # # CSV.write("ind.csv", tbl)

# figures = [] # this array will contain all of the figures
# for i in 1:2
#     f = figure(figsize=(11.69,8.27)) # A4 figure
#     plot(rand(5,100))
    
#     # ax = subplot(111)
#     # ax[:plot]() # random plot
#     push!(figures,f) # add figure to figures array
# end

# outfile = "fig.pdf"
# write_fig(figures, "fig.pdf")
