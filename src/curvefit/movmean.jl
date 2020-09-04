using Statistics

function movmean(x::AbstractArray{T,1}, halfwin::Integer = 2) where {T <: Real}
    n = length(x)
    z = zeros(n)
    for i = 1:n
        i_begin = i <= halfwin ? 1 : i - halfwin
        i_end = i <= n - halfwin ? i + halfwin : n
        # println((i_begin, i_end))
        z[i] = mean(@view x[i_begin:i_end])
    end
    z
end

weightedMean(x::AbstractArray{T, 1}, w::AbstractArray{T2, 1}) where {T <: Real, T2 <: Real} = sum(x .* w) / sum(w)

# 4 times slower
function movmean(x::AbstractArray{T, 1}, w::AbstractArray{T2, 1}, halfwin::Integer = 2) where {T <: Real, T2 <: Real}
    n = length(x)
    z = zeros(n)
    for i = 1:n
        i_begin = i <= halfwin ? 1 : i - halfwin
        i_end = i <= n - halfwin ? i + halfwin : n

        # println((i_begin, i_end))
        z[i] = weightedMean(view(x, i_begin:i_end), view(w, i_begin:i_end))
        # z[i] = weightedMean(x[i_begin:i_end], w[i_begin:i_end])
        # z[i] = sum(view(x, i_begin:i_end) .* view(w, i_begin:i_end)) / sum(view(w, i_begin:i_end))
    end
    z
end


export movmean, weightedMean
# x = [1, 2, 6, 5, 3, 2]
# x = rand(1000)
# w = ones(length(x))

# t_weighted = @benchmark movmean(x, w, 2)
# using BenchmarkTools
# # @benchmark movmean(x)
# @benchmark movmean(x, 2)
