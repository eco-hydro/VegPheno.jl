using LinearAlgebra


function sgmat_S(halfwin::Int = 1, d::Int = 2)
    frame = 2*halfwin + 1;
    mat = zeros(Int, frame, d+1)
    
    for i = 0:frame-1
        for j = 0:d
            mat[i+1, j+1] = (i - halfwin)^j; # fix solaris error
        end
    end
    mat
end

"""
B matrix of Savitzky Golay
"""
function sgmat_B(S::Array{Int, 2}) 
    r = qr(S)
    T = r.R' \ S';
    B = T' * T;
    return B;
end

"""
B matrix of weighted Savitzky Golay
"""
function sgmat_wB(S::Array{Int, 2}, w) 
    r = qr(repeat(sqrt.(w), 1, size(S, 2)) .* S)
    T = r.R' \ S';
    B = T' * T;
    B = repeat(w, 1, size(B, 2))' .* B
    return B;
end


"""
Savitzky Golay filter
"""
function SG(y::Array{T, 1}, halfwin=1, d=2) where T <: Real
    frame   = halfwin*2 + 1;

    S = sgmat_S(halfwin, d);
    B = sgmat_B(S);
    
    y_head = @view(B[1:halfwin+1, :]) * @view y[1:frame];

    n = length(y)
    y_mid = zeros(T, n-frame-1, 1)
    @inbounds for i = 1:n-frame-1
        y_mid[i] = dot( @view(B[halfwin+1, :]), @view y[i+1:i+frame] );
        # y_mid[i] = dot(B[halfwin+1, :], y[i:i+frame-1]);
    end

    y_tail = @view(B[halfwin+1:frame, :]) * @view y[n-frame+1:n];
    [y_head; y_mid; y_tail]
    # arma::colvec yfit  = join_vert(y_head, y_mid);
    # yfit = join_vert(yfit, y_tail);
    # return Rcpp::NumericVector(yfit.begin(), yfit.end());
end

export sgmat_S, sgmat_B, sgmat_wB, SG;
