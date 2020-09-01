using AbstractPlotting
using Makie

N = 100
r = range(-1, stop = 1, length = N)

# bunch of equations and inequalities
f1(x,y,z) = x.^2 .+ y.^2 .+ z.^2 #center sphere
f2(x,y,z) = y.^2 .+ z.^2 #command deck cylinder thing
f3(x,y,z) = x.^2 .+ 4 .* y.^2 #controls the flattened cylinder connecting center pod to wings
f4(x,y,z) = (y .* 0.7 .+ 0.05) #defines the diagonal spokes
f5(x,y,z) = (y .* 0.7 .- 0.05) #defines the diagonal spokes
f6(x,y,z) = abs.(x) + 0.3 .* abs.(y) #frame part of the wings

e1(x,y,z) = 0.12 .* (1 .- abs.(z)) #limits of a hexagonal tube in the inside of the craft
e2(x,y,z) = abs.(z) .* (abs.(z) .< 0.95) #outer limits of the wing plane
e3(x,y,z) = abs.(z) .* (abs.(z) .> 0.9) #inner limits of the wing plane
e4(x,y,z) = (abs.(x) + abs.(0.3 .*y)) .* ((abs.(x) + abs.(0.3 .* y)) .< 1) #frame of the wings
e5(x,y,z) = abs.(z) .* (abs.(z) .< 1.05) #outside thickness of wing frames, including the spokes
e6(x,y,z) = abs.(z) .* (abs.(z) .> 0.80) #inside thickness of wing frames, including the spokes
e7(x,y,z) = abs.(x) .* (abs.(x) .< 0.7) #length of the straight bars part of frames
e8(x,y,z) = abs.(y) .* (abs.(y) .> 0.9) #width of the straight bars part of frames
e9(x,y,z) = abs.(y) .* (abs.(y) .< 0.035) #the thickness of the horizontal reinforcing bar on the wing planes

amp = 15 #this just amplifies the "strength" of a volume, so that it shows up more clearly in the plot

# spawn the tie fighter
me = [(f1(x,y,z) .* f1(x,y,z).<0.2) .+ ((f2(x,y,z) .* f2(x,y,z).<0.02).*((x.<0.68).*(x.>0.50))) .+ amp .* (f3(x,y,z) .* (f3(x,y,z) .< e1(x,y,z))) .+ (e2(x,y,z).*e3(x,y,z).*e4(x,y,z)) .+ (e5(x,y,z).*e6(x,y,z)).*((e7(x,y,z)).*(e8(x,y,z)) .+ e9(x,y,z) .+ ((x.>f5(x,y,z)).*x).*((x.<f4(x,y,z)).*x) .+ (((-).(x).>f5(x,y,z)).*x).*(((-).(x).<f4(x,y,z)).*x) .+ ((f6(x,y,z).*(f6(x,y,z).<1.05)).*(f6(x,y,z).*(f6(x,y,z).>0.95)))) for x=r, y=r, z=r]

me2 = me
for i = 1:length(r)
    me2[:,:,i] = me2[:,:,i] .- min(me2[:,:,i]...)
    me2[:,:,i] = me2[:,:,i] ./ max(me2[:,:,i]...)
end
contour(me2, colormap = :Purples, colorrange = (0.001,0.6), alpha = 1.0, levels = 10)
