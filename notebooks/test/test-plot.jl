using Plots
gr()

mat = randn(10,10)
heatmap(mat)

# using GMT
# imshow(mat, cmap="rainbow", fmt="png")

