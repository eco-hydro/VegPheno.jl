# http://juliamath.github.io/Interpolations.jl/latest/convenience-construction/#Convenience-notation-1
using Interpolations

f(x) = log(x)
xs = 1:0.2:5
A = [f(x) for x in xs]

# extrapolation with linear boundary conditions
extrap = LinearInterpolation(xs, A, extrapolation_bc = Line())

@test extrap(1 - 0.2) # ≈ f(1) - (f(1.2) - f(1))
@test extrap(5 + 0.2) # ≈ f(5) + (f(5) - f(4.8))
