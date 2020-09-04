
@testset "whittaker smoother" begin
    y = [5.0, 8, 9, 10, 12, 10, 15, 10, 9, 19, 19, 17, 13, 14, 18, 19, 18, 12, 18, 
        24, 0, 1, 18, 17, 6, 13, 12, 10, 9, 6, 6, 3, 4, 3, 3, 3, 2, 3, 4, 4, 3, 2, 3, 3, 1, 3];
    
    m = length(y)
    w = ones(m)
    c = zeros(Float32, m)
    d = zeros(Float32, m)
    e = zeros(Float32, m)

    lambda = 2.0
    z = ones(m)
    cve = whit2!(y, w, lambda, z, c, d, e, include_cve = true)
    z, cve2 = whit2(y, w, lambda)

    @test cve == cve
    lamb_cv = lambda_cv(y, w, is_plot = true)
    lamb_vcurve = lambda_vcurve(y, w)
    
    z1, cve_cv = whit2(y, w, lamb_cv)
    z2, cve_vcurve = whit2(y, w, lamb_vcurve)
    @test cve_cv < cve
    @test cve_vcurve < cve
    @test cve_cv < cve_vcurve
end

