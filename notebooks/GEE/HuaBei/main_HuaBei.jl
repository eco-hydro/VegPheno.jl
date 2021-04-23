using DataFrames, CSV
using JLD2
using phenofit
using Lazy, Query
using Printf
using Dates
using Plots
using Pkg
pyplot()

"hello"
begin
    st = DataFrame(CSV.File("/mnt/n/Research/GEE_repos/gee_whittaker/temp/st-doubleGrowingSeason_st190.csv"))
    df = DataFrame(CSV.File("/mnt/n/Research/GEE_repos/gee_whittaker/temp/df-doubleGrowingSeason_st190.csv"))
    df = df[!, [:site, :t, :y, :FparExtra_QC]] |> 
        @rename(:t => :date, :FparExtra_QC => :QC_Extra) |> 
        @mutate(y = _.y/1.0) |> 
        @replacena(:y => 0.1) |> 
        @replacena(:QC_Extra => 127) |> 
        @filter(_.date >= Date("2015-01-01")) |> 
        DataFrame
    # df = df |> 
    df.QC_Extra = convert.(UInt8, df.QC_Extra);
    df.w, QC_flag = qc_FparLai(df.QC_Extra, wmid = 0.5, wmax = 0.8); # Initial weights

    # clamp!(df.y, -1, 10.0);
    set_value!(df.y, df.y .> 10, 0.1)
    # set_value!(df.QC_Extra, )
    describe(df) # summary(df)

    # df[df.Lai_500m .=== missing, :]
    # df[df.y .=== missing, :Lai_500m] = -10
    # df[df.Lai_500m .=== missing, :Lai_500m] = 0
    sites = unique(df.site)
    sitename = sites[1]
    st = st[match2(sites, st.site), :] |> 
        @filter(_.lat >= 30) |> DataFrame
    sites = st.site
end
