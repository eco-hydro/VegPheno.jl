using phenofit

begin
    y = [5.0, 8, 9, 10, 12, 10, 15, 10, 9, 19, 19, 17, 13, 14, 18, 19, 18, 12, 18, 24, 0, 1, 18, 17, 6, 13, 12, 10, 9, 6, 6, 3, 4, 3, 3, 3, 2, 3, 4, 4, 3, 2, 3, 3, 1, 3];
    # n = length(x)
    m = length(y)
    w = ones(m)
    c = zeros(Float32, m)
    d = zeros(Float32, m)
    e = zeros(Float32, m)
    lambda = 2.0
    z = ones(m)
    cve = whit2!(y, w, lambda, z, c, d, e, include_cve = true)
end
