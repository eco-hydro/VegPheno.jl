"""
R version Whittaker Cross validation

Whittaker smoothing with second order differences
Computation of the hat diagonal (Hutchinson and de Hoog, 1986)

- `In` : data vector (y), weigths (w), smoothing parameter (lambda)
- `Out`: list with smooth vector (z), hat diagonal (dhat)

#author: 
Gianluca Frasso and Paul HC Eilers, 2015

#references

1. Gianluca Frasso and Paul HC Eilers, L- and V-curves for optimal smoothing, 2015
"""
function whit_cv(y, w, lambda = 2.0; include_cve = true)
    # w = y*0 .+ 1.0
    n     = length(y)
    g0    = ones(n)*6 #rep(6, n)
    
    g0[1] = g0[n]      = 1
    g0[2] = g0[n - 1]  = 5
    g1    = ones(n) * -4
    g1[1] = g1[n-1]    = -2
    g1[n] = 0
    g2 = ones(n)
    g2[n-1] = 0
    g2[n] = 0

    # Store matrix G = W + lambda * D’ * D in vectors
    g0 = g0 * lambda .+ w
    g1 = g1 * lambda
    g2 = g2 * lambda
    # Compute U’VU decomposition (upper triangular U, diagonal V)
    # print(g0)
    v  = g0
    u1 = zeros(n)
    u2 = zeros(n) 

    @inbounds for i = 1:n
        if (i > 1); v[i] -= v[i - 1] * u1[i - 1] ^ 2; end
        if (i > 2); v[i] -= v[i - 2] * u2[i - 2] ^ 2; end
        
        if (i < n) 
            u = g1[i]
            if (i > 1); u = u - v[i - 1] * u1[i - 1] * u2[i - 1]; end
            u1[i] = u / v[i]
        end
        if (i < n - 1); u2[i] = g2[i] / v[i]; end
    end
    # g0, g1, and g2 can be clear now

    # Solve for smooth vector
    z = 0 * y
    @inbounds for i = 1:n
        z[i] = y[i] * w[i]
        if (i > 1); z[i] -= u1[i - 1] * z[i - 1]; end
        if (i > 2); z[i] -= u2[i - 2] * z[i - 2]; end
    end
    z = z ./ v

    @inbounds for i = n:-1:1
        if (i < n); z[i] -= u1[i] * z[i + 1]; end
        if (i < n - 1); z[i] -= u2[i] * z[i + 2]; end
    end

    cve = -999.0
    if include_cve
        s0 = zeros(n)
        s1 = zeros(n)
        s2 = zeros(n)
        
        # Compute diagonal of inverse
        # params: v, u1, u2, s0, s1, s2
        for i = n:-1:1
            i1 = i + 1
            i2 = i + 2
            s0[i] = 1 / v[i]
            if (i < n) 
                s1[i] =  - u1[i] * s0[i1]
                s0[i] = 1 / v[i] - u1[i] * s1[i]
            end
            if (i < n - 1) 
                s1[i] =  - u1[i] * s0[i1] - u2[i] * s1[i1]
                s2[i] =  - u1[i] * s1[i1] - u2[i] * s0[i2]
                s0[i] = 1 / v[i] - u1[i] * s1[i] - u2[i] * s2[i]
            end
        end
        r = @. (y - z) / (1 - s0)
        cve = sqrt(sum(r.*r/n))
    end
    # return(list(z = z, dhat = s0, cve))
    z, cve
end

# fid = matopen("/mnt/n/Research/PML_V2/pkg_smooth/y.mat")
# y = read(fid, "y")[:,1]
# @time z, cve = whit_cv(y, w, 2.0)

# w = y*0 .+ 1
# @benchmark for i = 1:1e5
#     z1, cve = whit_cv(y, w, 2.0)
# end
# # 0.599415 seconds (2.70 M allocations: 1.687 GiB, 11.99% gc time)

# @time for i = 1:1e5
#     z2, cve2 = whit2(y, w, 2.0, include_cve = true)
# end
# 0.407989 seconds (400.00 k allocations: 227.356 MiB, 11.67% gc time)
