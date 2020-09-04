"""
    whittaker2(y, w, lambda) -> z

Perform a second-order differences Whittaker-Henderson smoothing and interpolation.
# Citation
'Smoothing and interpolation with finite differences' [Eilers P. H. C, 1994]
(URL: http://dl.acm.org/citation.cfm?id=180916)
"""
function whittaker2(y::Array{T,1}, w::Vector{T}, lambda::Float64) where{T <: Number}
  z = similar(y)
  return smooth2!(y, w, lambda, z)
end


"""
    whittaker2!(y, w, lambda) -> y

Perform an in-place second-order differences Whittaker-Henderson smoothing and interpolation on `y`.
"""
function whittaker2!(y::Array{T,1}, w::Vector{T}, lambda::Float64) where{T <: Number}
  return smooth2!(y, w, lambda, y)
end


"""
    smooth2!(y, w, lambda, z) -> z

Smooth and interpolate with second-order differences.
"""
function smooth2!(y::Array{T,1}, w::Vector{T}, lambda::Float64, z::Array{T,1}) where{T <: AbstractFloat}
  m = length(y)
  c = zeros(Float32, m)
  d = zeros(Float32, m)
  e = zeros(Float32, m)
  smooth2!(y, w, lambda, z, c, d, e)
end

function smooth2!(y::Array{T,1}, w::Vector{T}, lambda::Float64, z::Array{T,1}, 
    c::Array{T2,1}, d::Array{T2,1}, e::Array{T2,1}) where{T <: AbstractFloat, T2 <: AbstractFloat}
  # init
  m = length(y)
  # c = zeros(Float32, m)
  # d = zeros(Float32, m)
  # e = zeros(Float32, m)
  # c = Array{Float32}(m)
  # d = Array{Float32}(m)
  # e = Array{Float32}(m)
  @inbounds @fastmath begin
    # init (1)
    w0 = w[1]
    d1 = d[1] = w0 + lambda
    e1 = e[1] = lambda/d1
    z1 = z[1] = w0*y[1]
    c1 = c[1] = -2*lambda/d1

    # init (2)
    w0 = w[2]
    d2 = d[2] = w0 + 5*lambda - d1*c1^2
    e2 = e[2] = lambda/d2
    z2 = z[2] = w0*y[2] - c1*z1
    c1 = c[2] = (-4*lambda - d1*c1*e1)/d2

    d12 = (d1, d2)
    e12 = (e1, e2)
    z12 = (z1, z2)
  end

  # compute intermediate values
  @inbounds @fastmath for i = 3:(m-2)
    w0 = w[i]
    d1 = d[i] = w0 + 6*lambda - c1^2*d12[2] - e12[1]^2*d12[1]
    e1 = e[i] = lambda/d1
    z1 = z[i] = w0*y[i] - c1*z12[2] - e12[1]*z12[1]
    c1 = c[i] = (-4*lambda - d12[2]*c1*e12[2])/d1

    d12 = shift(d12, d1)
    e12 = shift(e12, e1)
    z12 = shift(z12, z1)
  end

  @inbounds @fastmath begin
    # compute pre-last values
    i1 = m - 2
    i2 = m - 3
    w0 = w[m-1]
    e2 = e12[1]
    d1 = d[m-1] = w0 + 5*lambda - c1^2*d12[2] - e12[2]^2*d12[1]
    z1 = z[m-1] = w0 * y[m-1] - c1*z12[2] - e2*z12[1]
    c1 = c[m-1] = (-2*lambda - d12[2]*c1*e12[2])/d1

    # compute last values
    i1 = m - 1
    i2 = m - 2
    w0 = w[m]
    d2 = d[m] = w0 + lambda - c1^2*d1 - e2^2*d12[2]
    z2 = z[m] = (w0*y[m] - c1*z1 - e2*z12[2])/d2

    z1 = z[m-1] = z1/d1 - c1*z2

    z12 = (z2, z1)
  end

  # compute result
  @inbounds for i = (m-2):-1:1
    z1 = z[i] = z[i]/d[i] - c[i]*z12[2] - e[i]*z12[1]
    z12 = shift(z12, z1)
  end

  return z
end

"""
    shift(t, item) -> u

Shift `t` to the left, dropping the head, and append `item`.
"""
@inline shift(t::Tuple, item) = (Base.tail(t)..., item)
