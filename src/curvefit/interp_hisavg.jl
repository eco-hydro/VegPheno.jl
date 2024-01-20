

"""
dn = get_dn(date, 8)
y_his = interp_hisavg(y, dn)
"""
function interp_hisavg(y, flag)
  grps = unique(flag) |> sort
  n = length(grps)
  out = zeros(n)
  @inbounds for i = 1:length(grps)
    out[i] = mean(y[flag.==grps[i]])
  end
  I = match2(flag, grps)
  out[I]
end

## stop at here
# I need a historical average
