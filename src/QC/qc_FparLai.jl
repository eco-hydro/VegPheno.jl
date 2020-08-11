
function getBits(x::AbstractArray{T,1}, i_start::Integer, i_end::Integer = i_start) where {T<:Integer}
    i_start = Int8(i_start)
    i_end   = Int8(i_end)
    
    n  = i_end - i_start + Int8(1)
    a1 = Int8(2)^i_start
    Sn = a1 * (Int8(2)^n - Int8(1))
    (Sn .& x) .>> i_start
end

function getBits(x::T, i_start::Integer, i_end::Integer = i_start) where {T<:Integer}
    n  = i_end - i_start + Int8(1)
    a1 = Int8(2)^i_start
    Sn = a1 * (Int8(2)^n - Int8(1))
    (Sn & x) >> i_start
end

"""
    Init weights for MODIS FPAR/LAI

#return 
QC_flag: [1:6] corresponding to ["good", "marginal", "snow", "cloud", "aerosol", "shadow"]
"""
function qc_FparLai(QA; wmin = 0.2, wmid = 0.5, wmax = 1.0)
    n  = length(QA)

    level_names_r = ["good", "marginal", "snow", "cloud", "aerosol", "shadow"]
    QC_flag = ones(Int8, n)
    w = ones(Float32, n) .* wmax # default is zero

    QC_flag[getBits(QA, 3) .== Int(1)] .= Int8(5) # "aerosol"
    QC_flag[getBits(QA, 6) .== Int(1)] .= Int8(6) # "shadow"
    QC_flag[getBits(QA, 5) .== Int(1)] .= Int8(4) # "cloud"
    QC_flag[getBits(QA, 2) .== Int(1)] .= Int8(3) # "snow"
    
    # is_good(x) = !in(x, Int8[2, 3, 4, 5, 6])
    is_bad(x) = x in Int8[3, 4, 6]
    # w[in.(QC_flag, )] .= wmin
    w[is_bad.(QC_flag)] .= wmin
    w[QC_flag .== Int8(5)] .= wmid
    
    (w, QC_flag)
end

export qc_FparLai, getBits

# x = Int8(11)
# println(bitstring(x))
# getBits(x, 3) 
# x2 = 
# println(bitstring.(x2))
# x = Int8[8, 9, 10]
# using Test
# @test getBits(Int8[8, 9, 10], 1, 3) == Int8[4, 4, 5]
