
begin
    res = []
    # for sitename = sites
    for i in 1:length(sites)
        # println(i)
        sitename = sites[i]
        # 1. Interp NA values first
        d = df[df.site .== sitename, Not([:site])]

        loc =  st[st.site .== sitename, :]
        prefix = @sprintf("[%03d_%s] [%.5f, %.5f]", i, sitename, loc.lon[1], loc.lat[1])
        outfile = "Figures/$prefix dGS.pdf"
        println(outfile)
    
        y2 = smooth_whit(d[:, :y], d.QC_Extra, d.date; 
            adj_factor = 10,
            outfile = outfile, title = prefix, is_plot = true)
        push!(res, y2)
    end
    # mat = hcat(res)
    # CSV.write(mat, "flux166_LAI-smoothed.csv")
    merge_pdf("Figures/*.pdf", "huabei_dGS_Terra-LAI phenofit-v0.1.6.pdf", is_del = true)
end
# using FileIO
# save("LAI_smoothed.jld", Dict("res" => res))
# save("LAI_smoothed2.jld", res)
