
diffs(x, d = 2) = d == 0 ? x : diffs(diff(x), d-1)

fidelity(y, z, w) = log(sum(@.(w*(y-z)^2)))
roughness(z, d = 2) = log(sum( diffs(z, d) .^ 2 ))

"""
lambda = v_curve(y, w, is_plot = false)

#return
- `lambda`: optimal lambda
"""
function lambda_vcurve(y, w; is_plot = true)
    lg_lambdas = 0.1:0.1:3
    n = length(lg_lambdas)
    fits = zeros(n)
    pens = zeros(n)
    for i in 1:n
        lambda = 10^lg_lambdas[i]
        z, cve = whit2(y, w, lambda, include_cve = false)
        # println(length(y), length(z), length(w))
        fits[i] = fidelity(y, z, w)
        pens[i] = roughness(z)
    end

    dfits = diff(fits)
    dpens = diff(pens)

    llastep = lg_lambdas[2] - lg_lambdas[1] 
    v = @. sqrt(dfits^2 + dpens^2)/(log(10) * llastep)
    lamids = (lg_lambdas[2:end] + lg_lambdas[1:end-1])/2
    k = argmin(v)
    opt_lambda = 10^lamids[k]
    # z = whit2(y, lambda, w)
    if is_plot
        plot_lambda(lamids, v)
    end
    opt_lambda
end


export lambda_vcurve
