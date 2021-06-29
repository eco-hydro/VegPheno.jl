using phenofit
using Test

@testset "Savitzky Golay filter" begin
    y = [1.0, 2, 5, 4, 3, 6]
    w = collect(1:7)
    halfwin = 3;
    S = sgmat_S(halfwin)
    B = sgmat_B(S)
    sgmat_wB(S, w)
    z = SG(y, 1, 2)

    @test z ≈ y
end

y = rand(100)
w = rand(100)
@time z1 = SG(y, 5)
@time z2 = SG(y, w, 5)

# using Plots
# p = plot(y)
# plot!(p, z1)
# plot!(p, z2)

# n = Int(1e5)
# y = rand(n)
# using BenchmarkTools

## test the used memory
# @time for i=1:1e3
#     z = SG(y)
# end
# using Plots
# gr()
# plot(y)
# plot!(z)
