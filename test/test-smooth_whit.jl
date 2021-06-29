
# @testset "whittaker smoother" 
begin
    y = [5.0, 8, 9, 10, 12, 10, 15, 10, 9, 19, 19, 17, 13, 14, 18, 19, 18, 12, 18, 
        24, 0, 1, 18, 17, 6, 13, 12, 10, 9, 6, 6, 3, 4, 3, 3, 3, 2, 3, 4, 4, 3, 2, 3, 3, 1, 3];
    y = [y; y; y; y];
    m = length(y)
    w = ones(m)
    c = zeros(Float32, m)
    d = zeros(Float32, m)
    e = zeros(Float32, m)

    lambda = 2.0
    z = ones(m)
    cve = whit2!(y, w, lambda, z, c, d, e, include_cve = true)
    z, cve2 = whit2(y, w, lambda)

    @test cve == cve2
    lamb_cv = lambda_cv(y, w, is_plot = true)
    lamb_vcurve = lambda_vcurve(y, w)
    
    z1, cve_cv = whit2(y, w, lamb_cv)
    z2, cve_vcurve = whit2(y, w, lamb_vcurve)
    @test cve_cv < cve
    @test cve_vcurve < cve
    @test cve_cv < cve_vcurve
end

# using BenchmarkTools
# @benchmark
# 4 times faster than R
# @time for i in 1:1e4
#     lamb_vcurve = lambda_vcurve(y, w)
# end
# @time lamb_vcurve = lambda_vcurve(y, w)

# @time @benchmark lamb_cv = lambda_cv(y, w)
# BenchmarkTools.Trial: 
#   memory estimate:  412.55 KiB
#   allocs estimate:  374
#   --------------
#   minimum time:     172.600 μs (0.00% GC)
#   median time:      179.300 μs (0.00% GC)
#   mean time:        198.880 μs (3.88% GC)
#   maximum time:     1.882 ms (70.58% GC)
