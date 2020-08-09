"""
    whittaker1(y, w, lambda) -> z

Perform a first-order differences Whittaker-Henderson smoothing and interpolation.
# Citation
'Smoothing and interpolation with finite differences' [Eilers P. H. C, 1994]
(URL: http://dl.acm.org/citation.cfm?id=180916)
"""
function whittaker1(y::Array{T,1}, w::Array{T,1}, lambda::Float64) where{T <: Number}
  z = similar(y)
  return smooth1!(y, w, lambda, z)
end


"""
    whittaker1!(y, w, lambda) -> y

Perform an in-place first-order differences Whittaker-Henderson smoothing and interpolation on `y`.
# Citation
'Smoothing and interpolation with finite differences' [Eilers P. H. C, 1994]
(URL: http://dl.acm.org/citation.cfm?id=180916)
"""
function whittaker1!(y::Array{T,1}, w::Array{T,1}, lambda::Float64) where{T <: Number}
  return smooth1!(y, w, lambda, y)
end


"""
    smooth1!(y, w, lambda, z) -> z

Smooth and interpolate with first-order differences.
"""
function smooth1!(y::Array{T,1}, w::Array{T,1}, lambda::Float64, z::Array{T,1}) where{T <: Number}
  # init
  m = length(y)
  c = zeros(Float64, m)
  d = zeros(Float64, m)
  @inbounds @fastmath begin
    w0 = w[1]
    d1 = d[1] = w0 + lambda
    c1 = c[1] = -lambda/d1
    z1 = z[1] = w0*y[1]
  end

  # compute intermediate values
  @inbounds @fastmath for i = 2:(m-1)
    w0 = w[i]
    d1 = d[i] = w0 + 2*lambda - c1^2*d1
    z1 = z[i] = w0*y[i] - c1*z1
    c1 = c[i] = -lambda/d1
  end

  # compute last values
  @inbounds @fastmath begin
    w0 = w[m]
    d1 = d[m] = w0 + lambda - c1^2*d1
    z1 = z[m] = (w0*y[m] - c1*z1)/d1
  end

  # compute result
  @inbounds @fastmath for i = (m-1):-1:1
    z1 = z[i] = z[i]/d[i] - c[i]*z1
  end

  return z
end
