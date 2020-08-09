using Dates
import CSV
import AstroTime


function get_LAI_date()
    d_date = CSV.read("/mnt/n/MODIS/MODIS.jl/whittaker2/examples/LAI_dates.csv", comment = "#")
    date = d_date.date[:]
end

"""
    date_doy(str) -> date
Convert "YYYYDDD" to date
"""
date_doy(x::String = "2020079") = Date(DateTime(AstroTime.UTCEpoch(x, DateFormat("yyyyD"))))

convert2int(x) = convert.(Int32, x)

function plot_input(date, val, QC_flag, year_lims = (2000, 2007))
    level_names = ["snow", "cloud", "shadow", "aerosol", "marginal", "good"]
    level_names_r = ["good", "marginal", "snow", "cloud", "aerosol", "shadow"]
    I_x, I_y = match2(level_names, level_names_r)
    flgs = I_x
    # flgs = [6, 5, 1, 2, 4, 3]
    qc_shape    = [:circle, :rect, :xcross, :dtriangle, :dtriangle, :utriangle]
    qc_colors   = ["grey60", "#00BFC4", "#F8766D", "#C77CFF", "#B79F00", "#C77CFF"]
    qc_size     = [3.5, 4, 4, 3.5, 3.5, 3.5] .+ 1

    year_min = year_lims[1]
    year_max = year_lims[2]
    x_lims = Dates.value.((Date(year_min), Date(year_max)))
    xticks = @. Date(year_min:year_max, 1, 1)

    p = Plots.plot(date, val, 
        xticks = xticks, 
        xlims = x_lims,
        gridlinewidth = 1,
        grid = :x,
        label = "",
        # title = "hello",
        color = "black",
        framestyle = :box)
    # plot!(xlim = [Date(2000), Date(2006)])
    
    for i = 1:6
        ind = findall(QC_flag .== flgs[i])
        # println(i, " ", length(ind))
        scatter!(p, date[ind], val[ind], 
            markersize = qc_size[i],
            markerstrokewidth = 1,
            markerstrokecolor = qc_colors[i],
            label = level_names_r[i],
            markercolor = qc_colors[i], 
            markershape = qc_shape[i])
    end
    p
end

import PyCall
# , PyPlot
pdf = PyCall.pyimport("matplotlib.backends.backend_pdf")

function write_pdf(figures, file = "Plot.pdf")
    if isfile(file); rm(file); end

    pdffile = pdf.PdfPages(file) # create pdf file
    [pdffile.savefig(f) for f in figures] # add figures to file
    pdffile.close() # close pdf file    
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


