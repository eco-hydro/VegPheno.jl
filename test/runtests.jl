using phenofit
using Test

# println(dirname(@__FILE__))
# println(pwd())

# cd(dirname(@__FILE__)) do
    include("test-smooth_whit.jl")
    include("test-smooth_SG.jl")
    include("test_wTSM.jl")
    # include("test_whittaker.jl")
    include("test-lambda_init.jl")
# end
