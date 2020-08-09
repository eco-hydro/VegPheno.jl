## fix for heatmap visualization
function spatial_array(x::Array{T,2}) where { T <: Real}
    flipud(transpose(x))
end

function flipud(x)
    x[end:-1:1, :]
end
