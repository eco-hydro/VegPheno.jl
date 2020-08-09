using Statistics


"""
Type-2 kurtosis and skewness
"""
function kurtosis(x::Array{AbstractFloat, 1}) 
    n = length(x)
    x = x .- mean(x)
    r = n * sum(x.^4)/(sum(x.^2)^2)

    ((n + 1) * (r - 3) + 6) * (n - 1)/((n - 2) * (n - 3)) # type_2
    # r * (1 - 1/n)^2 - 3 # type_3
end

function skewness(x::Array{AbstractFloat, 1})
    n = length(x)
    x = x .- mean(x)
    r = sqrt(n) * sum(x.^3)/(sum(x.^2)^(3/2))
    r * sqrt(n * (n - 1))/(n - 2) # type2
    # r * ((1 - 1/n))^(3/2) # type3
end

function init_lambda(x::Array{AbstractFloat, 1})
    x_mean = mean(x)
    x_sd = std(x)

    cv   = x_sd/x_mean
    skew = skewness(x)
    kur  = kurtosis(x)
    lambda = 0.9809 + 0.7247 * x_mean - 2.6752 * x_sd - 0.3854 * skew - 0.0604 * kur
    10^lambda
end

function init_lambda(x::Array{AbstractFloat, 1}, coef::Array{AbstractFloat, 1})
    x_mean = mean(x)
    x_sd = std(x)

    cv   = x_sd/x_mean
    skew = skewness(x)
    kur  = kurtosis(x)
    
    lambda = coef[1] + coef[2] * x_mean + coef[3] * x_sd + coef[4] * skew + coef[5] * kur
    # lambda = 0.9809 + 0.7247 * x_mean - 2.6752 * x_sd - 0.3854 * skew - 0.0604 * kur
    10^lambda
end

# x = rand(100)
# x[3] = missing
# init_lambda(x)
# R"phenofit::init_lambda($x)"

# std(x)
# R"sd($x)"
# using RCall
# R"phenofit::kurtosis($x)"
# R"phenofit::skewness($x)"
