mutable struct options_season
    r_min
    r_max
    
end

function findpeaks_season(z; 
    minpeakdistance = 0, minpeakheight = 0,
    r_max = 0, r_min = 0, rtrough_max = 0.7,
    nups = 1, ndowns = nups)
    
    A = maximum(z) - minimum(z)
    A_max = r_max*A
    A_min = r_min*A
    # println("A = $A, A_max = $A_max, A_min = $A_min")

    # 1. all peaks and troughs
    d_max = findpeaks(z; zerostr='+', 
        A_max = A_max, 
        A_min = A_min,
        minpeakdistance = minpeakdistance,
        minpeakheight = minpeakheight,
        nups = nups, ndowns = ndowns, 
        history = true) #|> DataFrame
    
    # add 
    check_season!(d_max; r_max = r_max, r_min = r_min, rtrough_max = rtrough_max)
    d_max[d_max.diff_min .< A_min, :status] .= "A_min"
    d_max[d_max.diff_max .< A_max, :status] .= "A_max"
    
    # 2. min的筛选条件相对宽松
    d_min = findpeaks(-z; zerostr='-', 
        A_max = A_max, 
        # A_min = A_min,
        minpeakdistance = minpeakdistance, 
        nups = 0, 
        history = true) #|> DataFrame
    Dict("max" => d_max, "min" => d_min)
end

function meltPeakTrough(d)
    d_max = d["max"]
    d_min = d["min"]

    d_max[:, :type] .= 1
    d_min[:, :type] .= -1
    d_season = [d_min; d_max]
    sort!(d_season, [:idx])
    d_season
end
