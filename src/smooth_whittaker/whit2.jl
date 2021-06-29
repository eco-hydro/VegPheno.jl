"""
Second-order differences Whittaker-Henderson smoothing

z, cve = whit2(y, w, lambda)
whit2(y, w, lambda, z)
whit2(y, w, lambda, z, c, d, e)

# Citation
'Smoothing and interpolation with finite differences' [Eilers P. H. C, 1994]
(URL: http://dl.acm.org/citation.cfm?id=180916)
"""
function whit2(y::Array{T,1}, w::Array{T2,1}, lambda::Float64; include_cve = true) where{
    T <: Real, T2 <: Real }

    m = length(y)
    z = zeros(T, m)
    c = zeros(Float32, m)
    d = zeros(Float32, m)
    e = zeros(Float32, m)
    cve = whit2!(y, w, lambda, z, c, d, e, include_cve = include_cve)
    z, cve
    # return z
end

function whit2!(y::Array{T,1}, w::Array{T2,1}, lambda::Float64, z::Array{T,1}; include_cve = true) where{
    T <: Real, T2 <: Real }

    m = length(y)
    c = zeros(Float32, m)
    d = zeros(Float32, m)
    e = zeros(Float32, m)
    cve = whit2!(y, w, lambda, z, c, d, e, include_cve = include_cve)
    cve
end

function whit2!(y::Array{T,1}, w::Array{T2,1}, lambda::Float64, z::Array{T,1}, 
    c::Array{T3,1}, d::Array{T3,1}, e::Array{T3,1}; 
    include_cve = true) where{
        T <: Real, T2 <: Real, T3 <: AbstractFloat}
    
    # int i, i1, i2, m;
    # double lambda;
    # lambda = * lamb;
    d[1] = w[1] + lambda;
    c[1] = -2 * lambda / d[1];
    e[1] = lambda / d[1];
    z[1] = w[1] * y[1];
    d[2] = w[2] + 5 * lambda - d[1] * c[1] * c[1];
    c[2] = (-4 * lambda - d[1] * c[1] * e[1]) / d[2];
    e[2] = lambda / d[2];
    z[2] = w[2] * y[2] - c[1] * z[1];

    # for (i = 2; i < m - 1; i++) 
    m = length(y);
    @inbounds @fastmath for i = 3:(m-1)
        i1 = i - 1;
        i2 = i - 2;
        d[i] = w[i] + 6 * lambda - c[i1] * c[i1] * d[i1] - e[i2] * e[i2] * d[i2];
        c[i] = (-4 * lambda - d[i1] * c[i1] * e[i1]) / d[i];
        e[i] = lambda / d[i];
        z[i] = w[i] * y[i] - c[i1] * z[i1] - e[i2] * z[i2];
    end

    i = m - 1;
    i1 = i - 1; i2 = i - 2;
    d[m - 1] = w[m - 1] + 5 * lambda - c[i1] * c[i1] * d[i1] - e[i2] * e[i2] * d[i2];
    c[m - 1] = (-2 * lambda - d[i1] * c[i1] * e[i1]) / d[m - 1];
    z[m - 1] = w[m - 1] * y[m - 1] - c[i1] * z[i1] - e[i2] * z[i2];

    # println("d:", length(d), d)
    # println("c:", c)
    # println("e:", e)
    # println(z)
    i = m;
    i1 = i - 1; i2 = i - 2;
    d[m] = w[m] + lambda - c[i1] * c[i1] * d[i1] - e[i2] * e[i2] * d[i2];
    z[m] = (w[m] * y[m] - c[i1] * z[i1] - e[i2] * z[i2]) / d[m];
    z[m - 1] = z[m - 1] / d[m - 1] - c[m - 1] * z[m];
    
    # for (i = m - 2; 0 <= i; i--)
    @inbounds @fastmath for i in (m-2):-1:1
        z[i] = z[i] / d[i] - c[i] * z[i + 1] - e[i] * z[i + 2];
    end
    # c: u1, d: v, e: u2
    # cve = -990.0
    cve = ifelse(include_cve, whit2_hat(d, c, e, y, z, w), -999.0)
    # cve
end

# according to hat and return the generalized cross validation
function whit2_hat(v::Array{T, 1}, u1::Array{T, 1}, u2::Array{T, 1}, 
    y::Array{T2,1}, z::Array{T2, 1}, w::Array{T3,1}) where { T<:AbstractFloat, T2<:AbstractFloat, T3<:AbstractFloat}

    n   = length(v)
    # T = Float32;
    s0  = zeros(T, n)
    s1  = zeros(T, n)
    s2  = zeros(T, n)
    # # Compute diagonal of inverse
    # # params: v, u1, u2, s0, s1, s2
    @inbounds @fastmath for i = n:-1:1
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
    # s0
    r = @. (y - z) * w / (1 - s0)
    cve = sqrt(sum(r.*r/length(y)))
end

export whit2, whit2!,
    whit2_cpp, 
    whit2_hat
