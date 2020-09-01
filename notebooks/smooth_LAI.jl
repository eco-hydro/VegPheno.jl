using NetCDF
using Glob
using BenchmarkTools
# using RCall
# using Revise
using phenofit
using FileIO
using Printf

# include("main_ylu.jl")
include("main_phenofit.jl")
# ------------------------------------------------------------------------------
indir = "/mnt/n/MODIS/Terra_LAI_nc/"
files = glob("*2_3.nc", indir)

# file = files[1]
# @time data_A = resample(ylu_A);
# perc = sum(data_A .> 0.1)/length(data_A) # 52.1%
# @time heatmap(spatial_array(data_A))

# begin    
#     LAI = NetCDF.open(files[1], "LAI")
#     QC = NetCDF.open(files[1], "qcExtra")    
#     I = ind[1]
#     # val = LAI[I[1], I[2], :] |> convert2int
#     # qc = QC[I[1], I[2], :] |> convert2int
# end

file_sample = "data/dat-Terra_LAI.jld"
if !isfile(file_sample)
    lst_LAI = map(file -> NetCDF.open(file, "LAI"), files)
    lst_QC  = map(file -> NetCDF.open(file, "qcExtra"), files)

    I = 1#ind[1]
    @time val = get_LAI(I) 
    @time qc = get_QC(I)

    ind = 1:20
    lst = [];
    @time for i = ind
        println(i)
        temp = (get_LAI(ind[i]), get_QC(ind[i]))
        push!(lst, temp)
    end
    save(file_sample, Dict("lst" => lst))
else
    lst = load(file_sample, "lst")
end

# using RCall
# lst = map(i -> (get_LAI(ind[i]), get_QC(ind[i])), 1:4)
# l = lst[1]
ind  = 1:20
date = get_LAI_date()

## should be able to calculate drought

using Plots
# pyplot()
# gr()

nptperyear = 46
is_plot    = true
niters     = 5
# lambda     = 0.5

# plotly()
using Plots
pyplot()
@time for i in 1:length(lst)    
    println(i)
    # if i != 2; continue; end
    # if i > 1; break; end
    # i = 1
# begin
    l = lst[i]
    global y = l[1]*1.0
    global w
    qc = l[2]
    w, QC_flag = qc_FparLai(qc, wmid = 0.5, wmax = 0.8)

    year_lims = (2000-1, 2010)
    year_min = year_lims[1]
    year_max = year_lims[2]
    x_lims = Dates.value.((Date(year_min), Date(year_max)))
    xticks = @. Date(year_min:year_max, 1, 1)

    p = plot_input(date, y, QC_flag, (2000, year_max))
    spike_rm!(y, 0.3, x = date, p = p, QC_flag = QC_flag, half_win = 1)
    
    my_cgrad = cgrad([:blue, "yellow", :red])
    plot!(p, xlim = x_lims, legend = :topleft, 
        title = "i = $i",
        size = (1200, 260), palette = my_cgrad)

    ## add curve fitting results into spike.pdf 
    # "#7F7F7F"
    colors = ["#0000FF" "#FFFF00" "#FF7F00" "#FF0000"]
    p_w = plot(date, w, xlim = x_lims, frame = :box, xticks = xticks)

    # println(w)
    for i in 1:niters
        # println("outside y: ", sum(y))
        # lambda = lambda_vcurve(y, w, is_plot = false)
        lambda = lambda_cv(y, w, is_plot = false)
        yfit, cve = whit2(y, w, lambda)
        
        global w = wBisquare(y, yfit, w, QC_flag, iter = i, wmin = 0.1, step = 0.3)
        if is_plot
            # , color = colors[i]
            plot!(p, date, yfit, linewidth = 0.8, label = "iter $i")
            # plot!(p_w, date, w, lw = 0.5, label = "iter $i")
        end
    end
    ## 3. add subplot
    # plot(p, p_w, layout = (2, 1), size = (1200, 480))
    outfile = @sprintf("Figures/spikeV2_%02d.pdf", i)
    savefig(outfile)
end
merge_pdf("Figures/*.pdf", "Spike (dynamic-lambda) V7.pdf")


begin
    # qc2 = convert2int(qc)
    # R"lw <- phenofit::qc_FparLai($qc2)"
    # QC_flag2 = R"lw$QC_flag"
    # level_names = R"levels(lw$QC_flag)" |> x -> rcopy.(String, x)
    
    # global yfit
    for i in 1:niters
        yfit = whit2(y, w, lambda)
        global w = wBisquare(y, yfit, w, iter = i, wmin = 0.1)
        if is_plot; plot!(p, date, yfit, linewidth = 2, label = "iter $i"); end
    end

    # push!(ps, p)
    if is_plot
        # println(y)
        savefig(p, "Figures/b2_$i.png"); 
    end
    # plot(y)
end
# @run 

