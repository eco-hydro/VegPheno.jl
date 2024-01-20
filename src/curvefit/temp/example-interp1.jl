# http://juliamath.github.io/Interpolations.jl/latest/convenience-construction/#Convenience-notation-1
using Interpolations

f(x) = log(x)
xs = 1:0.2:5
A = [f(x) for x in xs]

# extrapolation with linear boundary conditions
extrap = LinearInterpolation(xs, A, extrapolation_bc=Line())

@test extrap(1 - 0.2) # ≈ f(1) - (f(1.2) - f(1))
@test extrap(5 + 0.2) # ≈ f(5) + (f(5) - f(4.8))


using CSV
df = CSV.read("/mnt/n/Research/phenology/fluxtidy2/flux212_MCD_smoothed_LAI.csv")
sitename = "AR-SLu"
d = df[df.site.==sitename, :]

using Plots
pyplot()


sitenames = unique(df.site)

nrow = 6
ps = []
for i = 1:6#length(sitenames)
  sitename = sitenames[i]
  d = df[df.site.==sitename, :]
  p = show_lai(d, i)
  # display(p)
  push!(ps, p)
end
plot(ps[1:6]..., layout=(6, 1), size=(800, 600))

function show_lai(d, i)
  # if mod(i -1, 6) == 0
  # p = plot(d.date, d.LAI)
  # else
  p = plot(d.date, d.LAI)
  # end
  plot!(p, d.date, d.LAI_smoothed)
  p
end

