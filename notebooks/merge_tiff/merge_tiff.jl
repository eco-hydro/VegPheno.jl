# import Pkg
using Distributed
# addprocs(2)

println(Threads.nthreads())
@everywhere include("MODIS.jl")
# Threads.threadid()

# str_extractfiles_i[1]
# years = 2010:2019
years = 2010
# years = reverse(years)
year = years[1]
for year in years
    if in(year, [2012, 2013, 2016, 2017]); continue; end
    
    # println(year)
    outdir = "/mnt/e/github/julia/nc/"
    # indir ="/mnt/n/MODIS/Terra_LAI/$year/"
    indir = "/mnt/n/Documents/MODIS_Albedo"
    println(indir)
    
    files = glob("*.tif", indir)
    file  = files[1]

    # println(files[1:5])
    str_chunks  = str_extract(files, r"\d{4}_\d{1}_\d") # -\d*
    lst_files = split(files, str_chunks);
    lst_files = reverse(lst_files)
    # Threads.@threads 
    for i in lst_files
        try
            tiff2nc(i, outdir)
            println("[ok] ", i[1])
        catch e
            println(i[1], e)
        end
    end
end
