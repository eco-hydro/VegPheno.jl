
diffs(x, d = 2) = d == 0 ? x : diffs(diff(x), d-1)

fidelity(y, z, w) = log(sum(@.(w*(y-z)^2)))
roughness(z, d = 2) = log(sum( diffs(z, d) .^ 2 ))

function v_curve(y, w, d = 2; is_plot = true)
    lg_lambdas = 0.1:0.1:3
    n = length(lg_lambdas)
    fits = zeros(n)
    pens = zeros(n)
    for i in 1:n
        lambda = 10^lg_lambdas[i]
        z = whit2(y, w, lambda)
        fits[i] = fidelity(y, z, w)
        pens[i] = roughness(z, d)
    end

    dfits = diff(fits)
    dpens = diff(pens)

    llastep = lg_lambdas[2] - lg_lambdas[1] 
    v = @. sqrt(dfits^2 + dpens^2)/(log(10) * llastep)
    lamids = (lg_lambdas[2:end] + lg_lambdas[1:end-1])/2
    k = argmin(v)
    opt_lambda = 10^lamids[k]
    # z = whit2(y, lambda, w)
    # opt = lambda

    if is_plot
        xlim = (0, 46*6)
        p_v = plot(lamids, v, label = "v_curve", frame = :box)
        scatter!(p_v, lamids, v, legend = false)
        scatter!(p_v, [lamids[k]], [v[k]], 
            m = (10, :transparent, stroke(1, "red")),
            legend = false)
        vline!(p_v, [lamids[k]], color = "red", linestyle = :dash)

        p1   = plot(y, xlim = xlim, frame = :box)
        z_2  = whit2(y, w, 2.0)
        z_15 = whit2(y, w, 15.0)
        z_opt = whit2(y, w, opt_lambda)
        plot!(p1, z_2, label = "lambda = 2")
        plot!(p1, z_15, label = "lambda = 15")
        plot!(p1, z_opt, label = "lambda = $(round(opt_lambda, digits = 3))")
        
        plot(p_v, p1, layout = @layout([a ; b]), size = (700, 480))
    end
    opt_lambda
end


export v_curve
