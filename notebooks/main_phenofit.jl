import CSV
using Dates
import AstroTime

function get_LAI_date()
    d_date = CSV.read("/mnt/n/MODIS/MODIS.jl/phenofit.jl/examples/LAI_dates.csv", comment = "#")
    date = d_date.date[:]
end

"""
    date_doy(str) -> date

Convert "YYYYDDD" to date
"""
date_doy(x::String = "2020079") = Date(DateTime(AstroTime.UTCEpoch(x, DateFormat("yyyyD"))))

# ------------------------------------------------------------------------------
get_value(I, fids) = begin
    vals = map(x -> x[I, 1, :], fids)
    # vals = map(x -> x[I[1], I[2], :], fids)
    vcat(vals...)
end

convert2int(x) = convert.(Int32, x)
get_LAI(I) = get_value(I, lst_LAI) #|> convert2int
get_QC(I) = get_value(I, lst_QC) #|> convert2int

function get_index(file)
    bbox = get_range(file)

    # function read_ylu(bbox)
    file_ylu = "/mnt/n/MODIS/Terra_LAI_ylu_2002-2019.nc"
    @time ylu_A = ncread2(file_ylu, "LAI_amplitude", bbox)
    # end
    ind = findall(ylu_A .>= 0.1)
end

# plot_input(date, val, QC_flag)
# savefig("phenofit.pdf")
# title!("hellos")
## Other parameters for scatter
# markershape = :hexagon,
# markeralpha = 0.6,
# markercolor = :green,
# markerstrokewidth = 3,
# markerstrokealpha = 0.2,
# markerstrokecolor = :black,
# markerstrokestyle = :dot
