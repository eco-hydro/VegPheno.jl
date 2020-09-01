using Dates
using Printf

function smooth_whit(y, qc, date; niters=5, 
    is_plot = true, title = "whittaker", 
    outfile = "Figures/Plot-smooth_whit.pdf")
    
    w, QC_flag = qc_FparLai(qc, wmid = 0.5, wmax = 0.8)

    year_lims = extrema(year.(date))
    # year_lims = (2000-1, 2010)
    year_min = year_lims[1]
    year_max = year_lims[2]
    nyear = year_max - year_min
    x_lims = Dates.value.((Date(year_min), Date(year_max)))
    xticks = @. Date(year_min:year_max, 1, 1)

    p = plot_input(date, y, QC_flag, (year_min, year_max))
    spike_rm!(y, 0.3, x = date, p = p, QC_flag = QC_flag, half_win = 1)
    
    my_cgrad = cgrad([:blue, "yellow", :red])
    plot!(p, xlim = x_lims, legend = :topleft, 
        title = title,
        size = (70*nyear, 260), palette = my_cgrad)

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
        
        w = wBisquare(y, yfit, w, iter = i, wmin = 0.1, step = 0.3)
        if is_plot
            # , color = colors[i]
            plot!(p, date, yfit, linewidth = 0.8, label = "iter $i")
            # plot!(p_w, date, w, lw = 0.5, label = "iter $i")
        end
    end
    ## 3. add subplot
    # plot(p, p_w, layout = (2, 1), size = (1200, 480))
    # outfile = "$prefix.pdf"
    if (is_plot); savefig(outfile); end
    y
end

export smooth_whit
