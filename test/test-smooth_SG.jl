# using phenofit
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
