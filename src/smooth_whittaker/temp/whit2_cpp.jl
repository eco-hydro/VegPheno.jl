# void smooth2(double * w, double * y, double * z, double * lamb, int * mm,
#     double * d, double * c, double * e)
# {

using Libdl

# if Base.Sys.islinux()
prefix = abspath("../deps/smooth_whit")
# prefix = "./nlminb"

# $(Libdl.dlext)
# $(Libdl.dlext)
const libpath = "$(prefix).so"

"""
Whittaker in c version
"""
function whit2_cpp(y::Array{T,1}, w::Array{T,1}, lambda::Float64) where{T <: AbstractFloat}
    m = length(y)
    z = zeros(T, m)
    c = zeros(Float64, m)
    d = zeros(Float64, m)
    e = zeros(Float64, m)
    
    whit2_cpp!(y, w, lambda, z, c, d, e)
    z
end

function whit2_cpp(y::Array{T,1}, w::Array{T,1}, lambda::Float64, z::Array{T,1}) where{T <: AbstractFloat}
    m = length(y)
    c = zeros(Float64, m)
    d = zeros(Float64, m)
    e = zeros(Float64, m)
    
    whit2_cpp!(y, w, lambda, z, c, d, e)
    z
end

function whit2_cpp!(y::Array{T,1}, w::Array{T,1}, lambda::Float64, z::Array{T,1}, 
    c::Array{T2,1}, d::Array{T2,1}, e::Array{T2,1}) where{T <: AbstractFloat, T2 <: AbstractFloat}
    
    m = Cint(length(y))
    ccall((:smooth2, phenofit.libpath), Cvoid, 
        (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), 
         w, y, z, [lambda], [m], c, d, e);
end

