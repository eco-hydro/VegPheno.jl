using phenofit
using Test

# println(dirname(@__FILE__))
# println(pwd())

# cd(dirname(@__FILE__)) do
    include("test-GEE_whit2.jl")
    include("test_wTSM.jl")
    # include("test_whittaker.jl")
    include("test-lambda_init.jl")
# end
