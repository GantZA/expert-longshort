"""Online ZANTICOR Expert Generating Algorithm
Inputs:
       X: Matrix of price relatives
       K: Window size parameter
       T: Total number of days of price relatives available
       H0: Matrix of previous days experts controls
       absExp: Boolean indicating whether the expert is
       absolute (TRUE) or active(FALSE)
Outputs:
       b: Vector of an individual expert's controls

Workflow:
The online ZANTICOR agent generating algorithm chooses stocks
by searching for correlations between stocks in consecutive
time periods. Essentially the algorithm tries to buy stocks
that will mean revert upwards and short stocks that will mean
revert downwards."""

function OnlineZAntiCor(X, K, T, H0, absExp)
    if T < 2*K
        b = H0
    else
        b = Vector{Float64}(size(X)[2]) .= 0
        exp_tup = X[:,:]
        M = size(exp_tup)[2]
        LX1 = exp_tup[end-2*K+1:end-K,:]-1
        LX2 = exp_tup[end-K+1:end,:]-1
        mu1 = mean(LX1,1)
        mu2 = mean(LX2,1)
        claims = Matrix(M,M) .= 0
        H1 = Vector{Float64}(M)

        if K > 1
            sigma1 = transpose(mapslices(std, LX1, [1]))
            sigma2 = transpose(mapslices(std, LX2, [1]))
            M_cov = (1/(K-1)) *
            (transpose(LX1-(ones(K)*mu1))) * (LX2-(ones(K)*mu2))
            M_cor = M_cov ./ (sigma1 * transpose(sigma2))
            M_cor[find(isnan.(M_cor))] = 0

            for j in 1:M
                claims[:,j] = Claim(j, M_cor[:,j],
                diag(M_cor), M, claims[:,j], mu2)
            end
        else
            sigma1 = zeros(M)
            sigma2 = zeros(M)
            M_cov = zeros(M,M)
            M_cor = ones(M,M)
            claims = eye(M)
        end
        if absExp == true
            transfers = H0 * transpose(ones(M)) .*
            claims ./ (claims * ones(M) * transpose(ones(M)))
            transfers[find(isnan.(transfers))] = 0
            for i in 1:M
                H1[i] = H0[i] + sum(transfers[:,i] -
                transfers[i,:])
            end
        else
            for i in 1:M
                H1[i] = H0[i] + 1/3*(sum(claims[:,i] -
                claims[i,:]))
            end
        end
        b = ReNormAgMix(H1, absExp)
    end
    return b
end

"""Additional function to calculate a claim for column j.
Julia works faster when loopingthrough columns than
through rows."""
function Claim(j, Mcorj, McorDiag, M, Claimj, mu)
    for i in 1:M
        if mu[i] >= mu[j] && Mcorj[i] > 0
            Claimj[i] = Mcorj[i] + max(0, -McorDiag[i]) +
            max(0, -McorDiag[j])
        end
    end
    return Claimj
end
