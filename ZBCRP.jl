""" Online ZBCRP and Anti-ZBCRP Expert Generating Algorithms
Inputs:
       X: Matrix of price relatives
       k: Window size parameter
       L: Free-Parameter
       Anti: Boolean indicating which algorithm to use. TRUE = Anti
       absExp: Boolean indicating whether the expert is absolute
       (TRUE) or active(FALSE)
       risk_aver_vec: Not in use
Outputs:
       b: Vector of an individual expert's controls
Workflow:
The online ZBCRP agent generating algorithms choose stocks by
searching for trends (ZBCRP) or mean-reversion (Anti-ZBCRP)
in the price relatives for a given window k. The ZBCRP tries
to buy stocks that are going up and shorts those that are going
The Anti-ZBCRP does the opposite and looks to buy stocks
that have gone down and sell stocks that have gone up
"""
using MathProgBase
using Ipopt

function OnlineZBCRP(X, k, Anti, absExp)
    exp_tup = X
    M = size(exp_tup)[2]
    onesM = ones(M)
    if Anti == false
        mu = transpose(mean(exp_tup,1))
    else
        mu = - transpose(mean(exp_tup,1))
    end

    if absExp == true
        if k < M
            sigma = eye(M)
            inv_sigma = sigma
        else
            sigma = cov(exp_tup)
            if cond(sigma) < (1/1e-2) && k > M
                inv_sigma = inv(sigma)
            else
                sigma = diagm(diag(sigma))
                if cond(sigma) > 1/1e-2
                    sigma = eye(M)
                    inv_sigma = inv(sigma)
                elseif any(sigma .== 0) == true
                    sigma = ZeroVar(sigma)
                    inv_sigma = inv(sigma)
                end
            end
        end
        b = OptimSemiLog(mu[:,1], sigma, 1)
    else
        if k < 3
            sigma = eye(M)
            inv_sigma = sigma
        else
            sigma = cov(exp_tup)
            if cond(sigma) < (1/1e-2) && k > M
                inv_sigma = inv(sigma)
            else
                sigma = diagm(diag(sigma))
                if cond(sigma) > 1/1e-2
                    sigma = eye(M)
                    inv_sigma = inv(sigma)
                elseif any(sigma .== 0) == true
                    sigma = ZeroVar(sigma)
                    inv_sigma = inv(sigma)
                end
            end
        end
        sigma_scale = transpose(onesM)*inv_sigma*onesM
        risk_aver = onesM' *abs.((inv_sigma*
        (mu*transpose(onesM) - onesM*transpose(mu))
        *inv_sigma*onesM)/sigma_scale)
        if risk_aver==0
            risk_aver = 1
        end
        b = inv_sigma/risk_aver *
        ((mu*transpose(onesM) - onesM*transpose(mu))/
        (sigma_scale))*inv_sigma*onesM
    end
    return b
end


""" Optimizer for absolute experts """
function OptimSemiLog(mu, Sigma, risk_aver)
    A = transpose(ones(size(mu)))
    sol = quadprog(mu, Sigma*risk_aver, A, '=', 1,
    0, 1, IpoptSolver(print_level=0))
    return sol.sol
end

function ZeroVar(S)
    Z_Ind = (diag(S) .== 0)
    S[Z_Ind, Z_Ind] = mean(diag(S))*eye(sum(Z_Ind))
    return S
end


a = [1 2 3 4 50]
b = test(a)
b[:] = a
