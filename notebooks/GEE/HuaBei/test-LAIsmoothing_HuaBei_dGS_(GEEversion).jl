include("main_HuaBei.jl")
using phenofit

## global variables 如何使用
i = 2
sitename = sites[i]
# 1. Interp NA values first
d = df[df.site .== sitename, Not([:site])]
loc =  st[st.site .== sitename, :]
prefix  = @sprintf("[%03d_%s] [%.5f, %.5f]", i, sitename, loc.lon[1], loc.lat[1])
outfile = "Figures/$prefix dGS.pdf"
# println(outfile)
# outfile = "$prefix dGS_(GEEversion).pdf"

y = d[:, :y]
w = d[:, :w]

# in this case, lambda_opt 
# guess_lambda works
# y = rand(230)
lambda_cv(y, d[:, :w], is_plot = true)
lambda_vcurve(y*2, w)

y2 = smooth_whit_GEE(d[:, :y], d[:, :w]; 
    # λ = 4.5226164468861, 
    adj_factor = 100,
    niters  = 3, 
    trs_high = 0.7, trs_low = 0.4, trs_bg = 0.2, 
    # step = 0.3,
    outfile = outfile, title = prefix, 
    is_plot = true);

for i = 1:length(sites)
    sitename = sites[i]

    d = df[df.site .== sitename, Not([:site])]
    loc =  st[st.site .== sitename, :]
    prefix  = @sprintf("[%03d_%s] [%.5f, %.5f]", i, sitename, loc.lon[1], loc.lat[1])
    outfile = "Figures/$prefix dGS.pdf"
    
    y2 = smooth_whit_GEE(d[:, :y], d[:, :w]; 
        # λ = 4.5226164468861, 
        adj_factor = 10,
        niters  = 3, 
        trs_high = 0.7, trs_low = 0.4, trs_bg = 0.2, 
        # step = 0.3,
        outfile = outfile, title = prefix, 
        is_plot = true);    
end
merge_pdf("Figures/*.pdf", "huabei_dGS_Terra-LAI phenofit-v0.1.6.pdf", is_del = true)
# save("LAI_smoothed.jld", Dict("res" => res))
# save("LAI_smoothed2.jld", res)
