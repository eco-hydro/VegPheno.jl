using Glob
using Dates

# x and y is equal length at here
# - `I_y`: which y is corresponding to current x[i]
function match2(x, y)
    I_y = ones(Int, length(x))
    for i in 1:length(x)
        I_y[i] = findfirst(x[i] .== y)
        # I_x[i] = findfirst(y[i] .== x)
    end
    I_y # 
end

# function match2(x, y)
#     I_x = ones(Int, length(x))
#     I_y = ones(Int, length(y))
#     for i in 1:length(x)
#         I_x[i] = findfirst(x[i] .== y)
#     end
#     for i in 1:length(y)
#         I_y[i] = findfirst(y[i] .== x)
#     end
#     I_x, I_y
# end

function CartesianIndex2Int(x, ind)
    I = LinearIndices(x)
    # I = 1:prod(size(x))
    I[ind]
end

"""
    str_extract(x::AbstractString, pattern::AbstractString)
    str_extract_all(x::AbstractString, pattern::AbstractString)

"""
function str_extract(x::AbstractString, pattern::AbstractString)
    r = match(Regex(pattern), basename(x))
    r === nothing ? "" : r.match
    # if ; r.match; else ""; end
end

function str_extract(x::Vector{<:AbstractString}, pattern::AbstractString)
    str_extract.(x, pattern)
end

"""
    merge_pdf("*.pdf", output="Plot.pdf")

Please install [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) first.
On Linux, `sudo apt install pdftk-java`.

merge multiple pdf files by `pdftk`
"""
function merge_pdf(input, output="Plot.pdf"; is_del=false)
    # input = abspath(input)
    files = glob(input)
    id = str_extract(basename.(files), "\\d{1,}")
    id = parse.(Int32, id) |> sortperm
    files = files[id]

    run(`pdftk $files cat output $output`)
    if is_del
        run(`rm $files`)
    end
    nothing
end


# # import PyCall
# # PyPlot
# # pdf = PyCall.pyimport("matplotlib.backends.backend_pdf")
# function write_pdf(figures, file = "Plot.pdf")
#     if isfile(file); rm(file); end
#     # pdf()
#     pdffile = pdf.PdfPages(file) # create pdf file
#     [pdffile.savefig(f) for f in figures] # add figures to file
#     pdffile.close() # close pdf file    
# end
get_dn(date, days=8) = fld.(Dates.dayofyear.(date) .- 1, days) .+ 1

set_value!(x, con, value) = begin
    x[con] .= value
    Nothing
end

export match2, split, str_extract, list_dir, CartesianIndex2Int, merge_pdf,
    @show_file, @show_pdf,
    @methods,
    @savefig,
    get_dn,
    set_value!
