# y
# w

using phenofit
using Plots
pyplot()
# gr()

include("dat_GEE.jl")
begin
    y = mat[:,1]
    w = mat[:,2]
    outfile = "test-GEE.pdf"
    # @run 
    r = GEE_smooth_whit(y, w, 
        outfile = outfile,
        λ = 4.5226164468861, 
        adj_factor = 1,
        niters = 2, 
        trs_high = 0.7, trs_low = 0.4, trs_bg = 0.2, 
        step = 0.3)';
    # show_pdf(outfile)
    # r = floor.(r)
end
# run("ls")
# show_pdf(outfile)
