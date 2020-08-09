# ProfileView.@profview 

n = 1000
y = rand(n)
w = rand(n)
yfit = rand(n)


@testset "weights updating" begin
    w_ts = wTSM(y, yfit, w, iter = 2)
    w_bi = wBisquare(y, yfit, w, iter = 2)
    
    @test length(w_ts) == n
    @test length(w_bi) == n
end

# using BenchmarkTools
# @benchmark wnew = wTSM(y, yfit, w, iter = 2)

# # Debugger.@run 
# @benchmark w2 = wBisquare(y, yfit, w, iter = 2)
