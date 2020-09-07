using Dates
using Printf

# - adj_factor: λ = lambda_opt / adj_factor
function GEE_smooth_whit(y, w; 
    λ = nothing,
    niters = 3, 
    step = 0.3,
    nptperyear = 46,
    adj_factor = 1.0,
    is_plot = true, 
    title = "whittaker", 
    outfile = "Figures/Plot-smooth_whit.pdf", 
    options...)
    
    ## 1. Init lambda
    # println(w)
    # λ = lambda_vcurve(y, w, is_plot = false)
    λᵢ = λ
    if isnothing(λ)
        # GEE has no the condition to calculate λ_cv or λ_vcurve
        # Note that the LAI input: real_value*10 
        coef = [1.77365505, 0.043062881, -0.034192178, -0.30107590, 0.03221195]; # 4y group
        # var formula = "1.77365505 +0.043062881*b('mean') -0.034192178*b('sd') -0.30107590*b('skewness') +0.03221195*b('kurtosis')";   // 4y
        λᵢ = lambda_init(y, coef)
        # lambda_i = lambda_cv(y, w, is_plot = false)
    end
    λᵢ = λᵢ/adj_factor
    # println("λ=", λᵢ)

    # w, QC_flag = qc_FparLai(qc, wmid = 0.5, wmax = 0.8)
    # year_lims = extrema(year.(date))
    # year_lims = (2000-1, 2010)
    # year_min = year_lims[1]
    # year_max = year_lims[2]
    # nyear = year_max - year_min
    # x_lims = Dates.value.((Date(year_min-1), Date(year_max+1)))
    # xticks = @. Date(year_min:year_max, 1, 1)
    n = length(y)
    x_lims = (1, n)
    xticks = nptperyear:nptperyear:n
    nyear = n/nptperyear
    t = 1:n
    p = plot(t, y, frame = :box)
    # p = plot_input(date, y, QC_flag, (year_min, year_max))
    # spike_rm!(y, 0.3, x = date, p = p, QC_flag = QC_flag, half_win = 1)
    my_cgrad = cgrad([:blue, "yellow", :red])
    plot!(p, xlim = x_lims, legend = :topleft, 
        title = "$title λ = $λᵢ",
        size = (70*nyear + 600, 250), palette = my_cgrad)

    ## add curve fitting results into spike.pdf 
    # "#7F7F7F"
    colors = ["#0000FF" "#FFFF00" "#FF7F00" "#FF0000"]
    p_w = plot(t, w, xlim = x_lims, frame = :box, xticks = xticks)

    yfit = [];
    for i in 1:niters
        # println("outside y: ", sum(y))
        y = floor.(y)
        yfit, cve = whit2(y, w, λᵢ)
        # println(y, yfit,w, i, step)
        w = wBisquare(y, yfit, w; iter = i, wmin = 0.05, step = step, options...)
        if is_plot
            # , color = colors[i]
            plot!(p, t, yfit, linewidth = 0.8, label = "iter $i")
            # plot!(p_w, t, w, lw = 0.5, label = "iter $i")
        end
        println("============================================================")
        println("iter $i")
        println("yfit:", round.(yfit, digits = 3))
        println("------------------------------------------------------------")
        # println("y:", round.(y, digits = 3))
        println("w:", round.(w, digits = 3))
    end
    ## 3. add subplot
    show_w = false
    if show_w; plot(p, p_w, layout = (2, 1), size = (1200, 480)); end
    # outfile = "$prefix.pdf"
    if (is_plot); savefig(outfile); end
    yfit
end

export GEE_smooth_whit
