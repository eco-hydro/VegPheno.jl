using Dates
using Printf


val_range = extrema;
val_A(x::Vector) = x[2] - x[1]

"""
    smooth_whit(y, qc, date;
        niters=5,
        λ=nothing,
        fun_λ=lambda_cv,
        adj_factor=1.0,
        is_plot=true, title="whittaker",
        outfile="Figures/Plot-smooth_whit.pdf",
        options...)
    
# Arguments

- adj_factor: λ = lambda_opt / adj_factor
- options...: other parameters to [wBisquare()]
"""
function smooth_whit(y, qc, date;
    niters=5,
    λ=nothing,
    fun_λ=lambda_cv,
    adj_factor=1.0,
    is_plot=true, title="whittaker",
    outfile="Figures/Plot-smooth_whit.pdf",
    options...)

    w, QC_flag = qc_FparLai(qc, wmid=0.5, wmax=0.8)

    ## For visualization
    if is_plot
        year_min, year_max = extrema(year.(date))
        nyear = year_max - year_min
        x_lims = Dates.value.((Date(year_min - 1), Date(year_max + 1)))
        xticks = @. Date(year_min:year_max, 1, 1)
        
        p = plot_input(date, y, QC_flag, (year_min, year_max), base_size=4)
        # spike_rm!(y, 0.3, x = date, p = p, QC_flag = QC_flag, half_win = 1)
        my_cgrad = cgrad([:blue, "yellow", :red])
        plot!(p, xlim=x_lims, legend=:topleft,
            title=title,
            size=(70 * nyear + 600, 250), palette=my_cgrad)
        colors = ["#00FF00" "#007F7F" "#0000FF" "#7F007F" "#FF0000"]
        p_w = plot(date, w, xlim=x_lims, frame=:box, xticks=xticks)
    end
    ## add curve fitting results into spike.pdf 
    # @save "debug_local.jld2" y w

    for i in 1:niters
        λᵢ = isnothing(λ) ? fun_λ(y, w, is_plot=false) / adj_factor : λ
        # println(λᵢ)
        yfit, cve = whit2(y, w, λᵢ)

        w = wBisquare(y, yfit, w; iter=i, wmin=0.05, options...)
        if is_plot
            plot!(p, date, yfit, linewidth=0.8, label="iter $i", color=colors[i])
            # plot!(p_w, date, w, lw = 0.5, label = "iter $i")
        end
    end
    ## 3. add subplot
    # plot(p, p_w, layout = (2, 1), size = (1200, 480))
    # outfile = "$prefix.pdf"
    if (is_plot)
        savefig(outfile)
    end
    y
end


# function plot_yobs()
# end

export smooth_whit
