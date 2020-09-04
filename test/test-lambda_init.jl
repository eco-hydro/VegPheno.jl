# using Random

@testset "GEE pkg_whit.whit2" begin
    # @examples
    # Random.seed!(1234)
    y = rand(100)
    coef = [0.9809, 0.7247, -2.6752, -0.3854, -0.0604];
    lamb = lambda_init(y, coef)
    @test lamb > 0
end
# methods(lambda_init)
