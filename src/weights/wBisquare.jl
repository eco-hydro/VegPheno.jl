using Statistics

"""
    wBisquare(y, yfit, w; iter = 2, to_upper = true)
wBisquare weights updating 
"""
function wBisquare(y::Array{T,1}, yfit::Array{T,1}, w::Array{T,1};
                   iter::Integer = 2, 
                   wmin::Float64 = 0.2, 
                   to_upper = true) where {T <: AbstractFloat}
    n = length(y)

    ymax = maximum(yfit)
    ymin = minimum(yfit)
    A = ymax - ymin;

    wnew   = zero(w)
    re     = yfit .- y
    re_abs = abs.(re)
    sc     = 6*median(re_abs)

    if to_upper
        I_pos = @. ((re > 0) & (re < sc) & (yfit > 0.3 * A + ymin))
    else
        I_pos = @. ((re < sc) & (yfit > 0.3 * A + ymin))
    end
    wnew[I_pos] = @. (1 - (re_abs[I_pos]/sc)^2)^2 * w[I_pos]

    # fix outliers
    wnew[re_abs .>= sc] .= wmin
    wnew[wnew .< wmin]  .= wmin
    wnew
end
