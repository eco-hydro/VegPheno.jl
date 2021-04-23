"""
lambda = v_curve(y, w, is_plot = false)

#return
- `lambda`: optimal lambda
"""
function lambda_cv(y, w; is_plot = true)
    lg_lambdas = 0.1:0.1:3
    n = length(lg_lambdas)

    cvs = zeros(n)
    # pens = zeros(n)
    for i in 1:n
        lambda = 10^lg_lambdas[i]
        z, cvs[i] = whit2(y, w, lambda)
        # fits[i] = fidelity(y, z, w)
        # pens[i] = roughness(z, d)
    end
    # dfits = diff(fits)
    # dpens = diff(pens)
    # llastep = lg_lambdas[2] - lg_lambdas[1] 
    # v = @. sqrt(dfits^2 + dpens^2)/(log(10) * llastep)
    # lamids = (lg_lambdas[2:end] + lg_lambdas[1:end-1])/2
    k = argmin(cvs)
    opt_lambda = 10^lg_lambdas[k]
    if is_plot; plot_lambda(y, w, lg_lambdas, cvs) |> display; end
    opt_lambda
end


# x: lambdas candidates
function plot_lambda(y, w, lg_lambdas, cvs)
    k = argmin(cvs)
    opt_lambda = 10^lg_lambdas[k]

    p_v = plot(lg_lambdas, cvs, label = "Generalized CV", frame = :box)
    scatter!(p_v, lg_lambdas, cvs, legend = false)
    scatter!(p_v, [lg_lambdas[k]], [cvs[k]], 
        m = (10, :transparent, stroke(1, "red")),
        legend = false)
    vline!(p_v, [lg_lambdas[k]], color = "red", linestyle = :dash)

    xlim = (0, length(y))
    p1   = plot(y, xlim = xlim, frame = :box)
    z_2,  = whit2(y, w, 2.0)
    z_15, = whit2(y, w, 15.0)
    z_opt, = whit2(y, w, opt_lambda)
    plot!(p1, z_2, label = "lambda = 2")
    plot!(p1, z_15, label = "lambda = 15")
    plot!(p1, z_opt, label = "lambda = $(round(opt_lambda, digits = 3))")
    plot(p_v, p1, layout = (1, 2), size = (700, 480))
end

export lambda_cv, plot_lambda
