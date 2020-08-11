using Statistics

"""
wBisquare weights updating 

wBisquare(y, yfit, w; iter = 2, wmin, to_upper = true)

# arguments
- `iter`: not used

# Bad points
- 1. under the yfit, in the growing season (yfit > 0.3 * A + ymin)
- 2. 
"""
function wBisquare(y::Array{T,1}, yfit::Array{T,1}, w::Array{T2,1}, QC_flag;
                   iter::Integer = 2, 
                   wmin::Float64 = 0.05, 
                   step::Float64 = 0.2, 
                   to_upper = true) where {T <: AbstractFloat, T2 <: AbstractFloat}
    n = length(y)

    ymax = maximum(yfit)
    ymin = minimum(yfit)
    A = ymax - ymin;

    wnew   = w
    re     = yfit .- y
    re_abs = abs.(re)
    sc     = 6*median(re_abs)

    if to_upper
        I_bad = @. ((re > 0) & (re < sc) & (yfit > 0.3 * A + ymin))
    else
        I_bad = @. ((re < sc) & (yfit > 0.3 * A + ymin))
    end
    wnew[I_bad] = @. (1 - (re_abs[I_bad]/sc)^2)^2 * w[I_bad]
    
    I_good = @. ((re < 0) & (yfit > 0.3 * A + ymin))
    wnew[I_good] = wnew[I_good] .+ step

    ## also need to change y to improve the upper envelope performance
    y[I_bad] = yfit[I_bad]
    # println("inside wBisquare: ", sum(y))

    # fix outliers
    I_outlier = (re_abs .> sc) # .& (QC_flag .!== Int(1)
    y[I_outlier] = yfit[I_outlier]
    wnew[I_outlier] .= wmin
    wnew[wnew .< wmin]  .= wmin

    # wmax = 2.0
    # wnew[wnew .>= 1.0] .= 1.0
    wnew
end
