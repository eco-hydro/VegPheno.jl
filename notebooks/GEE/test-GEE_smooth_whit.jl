y
w

using phenofit
using Plots
pyplot()

plot(y)

begin
    y = mat[:,1]
    w = mat[:,2]
    # @run 
    r = GEE_smooth_whit(y, w, lambda = 4.5226164468861, niters = 3, 
        outfile = "test-GEE.pdf",
        trs_high = 0.7, trs_low = 0.4, trs_bg = 0.2, 
        step = 0.3)';    
end
