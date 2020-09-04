using DataFrames, DataFramesMeta, CSV, TabularDisplay
using DataFramesMeta
using phenofit
using Lazy, Query, Pipe
using Printf
using Dates

# replace()
set_value!(x, con, value) = begin
    x[con] .= value
    Nothing
end

begin
    st = DataFrame(CSV.File("/mnt/n/Research/GEE_repos/gee_whittaker/st-doubleGrowingSeason_st190.csv"))
    df = DataFrame(CSV.File("/mnt/n/Research/GEE_repos/gee_whittaker/df-doubleGrowingSeason_st190.csv"))
    df = df[!, [:site, :t, :y, :FparExtra_QC]] |> 
        @rename(:t => :date, :FparExtra_QC => :QC_Extra) |> 
        @mutate(y = _.y/1.0) |> 
        @replacena(:y => 0.1) |> 
        @replacena(:QC_Extra => 127) |> 
        @filter(_.date >= Date("2015-01-01")) |> 
        DataFrame
    # df = df |> 
    df.QC_Extra = convert.(UInt8, df.QC_Extra);
    # clamp!(df.y, -1, 10.0);
    set_value!(df.y, df.y .> 10, 0.1)
    # set_value!(df.QC_Extra, )
    describe(df) # summary(df)
end

# df[df.Lai_500m .=== missing, :]
# df[df.y .=== missing, :Lai_500m] = -10
# df[df.Lai_500m .=== missing, :Lai_500m] = 0

sites = unique(df.site)
sitename = sites[1]
st = st[match2(sites, st.site), :] |> 
    @filter(_.lat >= 30) |> DataFrame
sites = st.site

# df |> @filter(_.site == sitename)
using Plots
pyplot()

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
            adj_factor = 1,
            outfile = outfile, title = prefix, is_plot = true)
        push!(res, y2)
    end

    # mat = hcat(res)
    # CSV.write(mat, "flux166_LAI-smoothed.csv")
    merge_pdf("Figures/*.pdf", "huabei_dGS_Terra-LAI phenofit-v0.1.6.pdf")
end

# using FileIO
# save("LAI_smoothed.jld", Dict("res" => res))
# save("LAI_smoothed2.jld", res)
