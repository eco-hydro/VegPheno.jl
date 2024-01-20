# , QC_flag
using Interpolations

"""
rm spikes according to the 1th order difference

spike_rm!(y, 0.5, x = date, QC_flag = QC_flag, is_plot = true)
"""
function spike_rm!(y, TRS=0.3; half_win=1, x=nothing, QC_flag=nothing,
  is_plot::Bool=true, p=nothing, marksize=5)

  index = 1:length(y)
  if (x === nothing)
    x = 1:length(y)
  end

  # diff_left  = abs.([0; diff(y)])
  # diff_right = [diff_left[2:end]; 0]
  n = length(y)
  y_diff = zeros(n)
  @inbounds for i in half_win+1:n-half_win
    # ind = i-half_win:i+half_win
    # ind = [i-half_win:i-1 i+1:i+half_win]
    # print(ind)
    left = minimum(abs.(y[i-half_win:i-1] .- y[i]))
    right = minimum(abs.(y[i+1:i+half_win] .- y[i]))
    y_diff[i] = min(left, right)
  end

  ymax = maximum(y)
  ymin = minimum(y)
  A = ymax - ymin
  TRS_val = A * TRS #+ ymin
  I_bad = y_diff .> TRS_val
  if QC_flag !== nothing
    # 无论如何不能在此步牺牲good values
    # .| (y_diff .> TRS_val + 0.2)
    I_bad = ((QC_flag .!== Int8(1)) .& I_bad)
  end

  ## 增加historical average, 检测3sd outlier
  ind_bad = findall(I_bad)
  # print(ind_bad)

  if (sum(I_bad) > 0)
    I_good = @. !I_bad
    # println(length(I_good))
    # println(index, ",", length(index))

    # # println(index[I_good])
    # println(length(y), length(y_diff))
    # println(y[y_diff .< TRS_val])
    fun = LinearInterpolation(index[I_good], y[I_good], extrapolation_bc=Line())
    y0 = deepcopy(y)
    y_bad = y[I_bad]
    y[I_bad] = fun(index[I_bad])

    if is_plot
      if p === nothing
        p = plot(x, y0, label="original", color="black")
      end
      # plot!(p, x, y, label = "spike removed", color = "blue", lw = 0.5)
      scatter!(p, x[I_bad], y_bad,
        markershape=:circle,
        # markercolor = "transparent", 
        # markeralpha = 0.5,
        m=(marksize + 2, :transparent, stroke(1, "red")),
        label="spike")
      scatter!(p, x[I_bad], y[I_bad],
        m=(marksize, "green", stroke(0, "green")), label="", legend=false)
      scatter!(p, x[I_bad], y[I_bad],
        m=(marksize + 2, :transparent, stroke(1, "green")), label="fixed")
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
