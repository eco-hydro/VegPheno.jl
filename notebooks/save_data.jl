ind = 1:20
lst = []
for i in ind
    push!(lst, (Int8[1, 2, 3, 4, 5], Int8[1, 2, 3, 4, 5, 6]))
end

# using JLD2

# JLD2 not work
using FileIO
save("a.jld", Dict("lst" => lst))

# @save "a.jld2" Dict("lst" => lst)
# save("example.jld2", Dict("hello" => "world", "foo" => :bar))
# load("a.jld", "lst")
