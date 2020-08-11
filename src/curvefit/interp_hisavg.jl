

doy = Dates.dayofyear.(date)
dn = fld.(doy .- 1, 8) .+ 1

grps = unique(dn)
n = length(grps)
out = zeros(n)
for i = 1:length(grps)
    ind = dn .== grps[i]
    out[i] = mean(y[ind])
end

## stop at here
# I need a historical average
I_x, I_y = match2(dn, grps)
