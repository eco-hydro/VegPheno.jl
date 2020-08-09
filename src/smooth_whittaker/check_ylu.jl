
function check_ylu!(yfit, ylu)
    yfit[ yfit .< ylu[1]] := ylu[1]
    yfit[ yfit .> ylu[2]] := ylu[2]
end

function smooth_whit()
end

# trs = 0.5 # Threshold for growing season
# iters = 2
# for i = 1:iters
# end

# lambda = 2.0
# z = whit2(y, w, lambda)
