"""
findpeaks

@author: Gerhard Aigner
# references
https://github.com/halleysfifthinc/Peaks.jl/issues/11#issuecomment-689998279
"""
function findpeaks(x::AbstractVector{T};
    nups::Int=1,
    ndowns::Int=nups,
    zerostr::Char='0',
    peakpat=nothing, 
    minpeakheight=typemin(T), 
    minpeakdistance::Int=1,
    threshold=zero(T),
    npeaks::Int=0,
    sortstr=false) where T
    
    zerostr ∉ ('0', '+', '-') && error("zero must be one of `0`, `-` or `+`")

    # generate the peak pattern with no of ups and downs or use provided one
    peakpat = Regex(peakpat === nothing ? "[+]{$nups,}[-]{$ndowns,}" : peakpat)

    # transform x into a "+-+...-+-" character string
    xs = String(map(diff(x)) do e
        e < 0 && return '-'
        e > 0 && return '+'
        return zerostr
    end)

    # find index positions and maximum values
    peaks = map(findall(peakpat, xs)) do m
        v, i = findmax(@view x[m])
        (;value=v, idx=first(m) + i - 1, start=first(m), stop=last(m) + 1)
    end

    # eliminate peaks that are too low
    filter!(peaks) do p
        p.value >= minpeakheight && p.value - max(x[p.start], x[p.stop]) >= threshold
    end

    # sort according to peak height
    if sortstr || minpeakdistance > 1
        sort!(peaks, by=x -> x.value; rev=true)
    end

    # find peaks sufficiently distant
    if minpeakdistance > 1
        removal = falses(length(peaks))
        for i in 1:length(peaks)
            removal[i] && continue
            for j in 1:length(peaks)
                removal[j] && continue
                dist = abs(peaks[i].idx - peaks[j].idx)
                removal[j] = 0 < dist < minpeakdistance 
            end
        end
        deleteat!(peaks, removal)
    end

    # Return only the first 'npeaks' peaks
    npeaks > 0 && resize!(peaks, min(length(peaks), npeaks))
    return peaks
end

export findpeaks
