# , QC_flag
using Interpolations
using Plots

"""
rm spikes according to the 1th order difference

spike_rm!(y, 0.5, x = date, QC_flag = QC_flag, is_plot = true)
"""
function spike_rm!(y, TRS = 0.5; x = nothing, QC_flag = nothing, 
    is_plot::Bool = true, p = nothing)

    index = 1:length(y)
    if (x === nothing); x = 1:length(y); end

    diff_left = abs.([0; diff(y)])
    diff_right = [diff_left[2:end]; 0]

    ymax = maximum(y)
    ymin = minimum(y)
    A = ymax - ymin;
    
    TRS_val = A*TRS #+ ymin
    I_bad = (diff_left .> TRS_val) .& (diff_right .> TRS_val)
    if QC_flag !== nothing
        # println(findall(I_bad))
        # println("bad:", findall(QC_flag .!== 1))
        # println("good:", findall(QC_flag .== 1))
        I_bad = (QC_flag .!== Int8(1)) .& I_bad
        # println(QC_flag[I_bad])
    end

    ind_bad = findall(I_bad)
    if (sum(I_bad) > 0)     
        I_good = @. !I_bad
        fun = LinearInterpolation(index[I_good], y[I_good], extrapolation_bc = Line())
        y0 = deepcopy(y)
        y_bad = y[I_bad]
        y[I_bad] = fun(index[I_bad])

        if is_plot
            if p === nothing;  p = plot(x, y0, label = "original", color = "black"); end
            # plot!(p, x, y, label = "spike removed", color = "blue", lw = 0.5)
            scatter!(p, x[I_bad], y_bad, 
                markershape = :circle, 
                # markercolor = "transparent", 
                # markeralpha = 0.5,
                m = (10, :transparent, stroke(1, "red")),
                label = "spike")
            scatter!(p, x[I_bad], y[I_bad],
                m = (6, "green", stroke(0, "green")), label = "fixed", legend = false)
            scatter!(p, x[I_bad], y[I_bad], 
                m = (10, :transparent, stroke(1, "green")), label = "fixed")
            # display(p)
        end
    end
end

export spike_rm!

# begin
#     y = [1, 2, 5, 7.0, 10, 13, 7, 5]
#     plot(y, label = "original")
#     spike_rm!(y)
#     plot!(y, label = "spike removed")
# end
