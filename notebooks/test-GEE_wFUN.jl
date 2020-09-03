using phenofit
using DataFrames
using CSV
using Query, Dates
# d = Data

begin
    d = DataFrame(CSV.File("/mnt/n/Research/GEE_repos/gee_whittaker/home2.csv")) |> 
        @filter(_.date <= Date("2018-12-31")) |> 
        DataFrame
    # df = df[!, [:site, :date, :Lai_500m, :FparLai_QC, :FparExtra_QC]] |> 
    #     @rename(:Lai_500m => :y, :FparLai_QC => :QC, :FparExtra_QC => :QC_Extra) |> 
    #     @mutate(y = _.y/10) |> 
    #     @replacena(:y => -0.1) |> 
    #     @replacena(:QC_Extra => 127) |> 
    # df = df |> 
end

outfile = "home.pdf"
prefix = "dGS"
y2 = smooth_whit(d[:, :LAI]*1.0, d.QCExtra, d.date; 
            niters=2,
            lambda = 6.7937,
            adj_factor = 1,
            outfile = outfile, title = prefix, is_plot = true);
