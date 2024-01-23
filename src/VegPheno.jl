module VegPheno

using Base: Float64
using StaticArrays: zeros, maximum
using Dates: floor, length
# using Plots
# using JLD2

export wTSM, wBisquare

include("main_Ipaper.jl")

include("QC/qc_FparLai.jl")

include("season/season.jl")

include("weights/wBisquare.jl")
include("weights/wTSM.jl")

include("curvefit/Curvefit.jl")

end
