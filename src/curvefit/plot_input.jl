
function plot_input(date, val, QC_flag, year_lims=(2000, 2010); base_size=4.5)
  # level_names = ["snow", "cloud", "shadow", "aerosol", "marginal", "good"]
  level_names_r = ["good", "marginal", "snow", "cloud", "aerosol", "shadow"]
  # I_x, I_y = match2(level_names, level_names_r)
  I_x = [1, 2, 3, 4, 5, 6]
  # print(I_x)
  flgs = I_x
  # flgs = [6, 5, 1, 2, 4, 3]
  qc_shape = [:circle, :rect, :xcross, :dtriangle, :dtriangle, :utriangle]
  qc_colors = ["grey60", "#00BFC4", "#F8766D", "#C77CFF", "#B79F00", "#C77CFF"]
  qc_size = [0.5, 0.5, 0.5, 0, 0, 0] .+ base_size

  year_min = year_lims[1]
  year_max = year_lims[2]
  x_lims = Dates.value.((Date(year_min), Date(year_max)))
  xticks = @. Date(year_min:year_max, 1, 1)

  p = Plots.plot(date, val,
    xticks=xticks,
    xlims=x_lims,
    gridlinewidth=1,
    grid=:x,
    label="",
    # title = "hello",
    color="black",
    framestyle=:box)
  # plot!(xlim = [Date(2000), Date(2006)])

  for i = 1:6
    ind = findall(QC_flag .== flgs[i])
    # print(ind)
    # println(i, " ", length(ind))
    scatter!(p, date[ind], val[ind],
      markersize=qc_size[i],
      markerstrokewidth=1,
      markerstrokecolor=qc_colors[i],
      label=level_names_r[i],
      markercolor=qc_colors[i],
      markershape=qc_shape[i])
  end
  # p = spike_rm!(val, 0.5, x = date, QC_flag = QC_flag, p = p)
  p
end


export plot_input
