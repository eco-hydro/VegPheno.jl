module phenofit

export  whittaker2,
        whittaker2!, 
        smooth2!, 
        smooth2_c!, 
        whit2, 
        whit2!,
        whit2_cpp, 
        wTSM, 
        wBisquare
        # whittaker1,
        # whittaker1!,

include("base/main_Ipaper.jl")

include("raster/raster.jl")
include("raster/ncread2.jl")

include("QC/qc_FparLai.jl")

include("smooth_whittaker/whit2_cpp.jl")
include("smooth_whittaker/whittaker2.jl")
include("smooth_whittaker/whit2.jl")
include("curvefit/v_curve.jl")
include("curvefit/plot_input.jl")

include("weights/wBisquare.jl")
include("weights/wTSM.jl")

include("curvefit/spike.jl")

end
