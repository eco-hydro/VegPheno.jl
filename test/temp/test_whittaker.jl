# using whittaker
# using Revise
# using Pkg
# Pkg.generate()

# y = [1.0, 2, 3, 10, 5, 6, 7, 8]
n = 1000
y = rand(n)
w = rand(n)
z = zeros(n)
lambda = 2.0

@testset "whittaker works" begin
    # z_cpp = whit2_cpp(y, w, lambda)
    z_kong = whit2(y, w, lambda)
    # z = whittaker2(y, w, lambda)
    # @test maximum( abs.(z_cpp - z_kong)) < 1e-5
end
# @run 
# # z = whittaker2(y, w, 2.0)
# m = Cint(length(y))
# c = zeros(Float64, m)
# d = zeros(Float64, m)
# e = zeros(Float64, m)
# lambda = 2.0

# # @run 
# using BenchmarkTools
# @time @benchmark z = whittaker1(y, w, 2.0)

# @profview smooth2!(y, w, lambda, z, c, d, e)

# @time @benchmark smooth2!(y, w, 2.0, z);
# @time @benchmark smooth2!(y, w, lambda, z, c, d, e);
# @time @benchmark smooth2_c!(y, w, lambda, z, c, d, e);

# # smooth2_c!(y, w, lambda, z, c, d, e)
# z = deepcopy(y)
# smooth2_c!(y, w, lambda, z, c, d, e)

# @profview smooth2_c!(y, w, lambda, z, c, d, e)
