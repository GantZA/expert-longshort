function OnlineFunction(g, q0, S_t, eta)
    if g == "Uni"
        q1 = S_t
    elseif g == "EG"
        if all(q0 == 0)
            q1 = S_t
        else
            q1 = q0 .* (exp.((eta*S_t)/(transpose(q0)*S_t)))
        end
    elseif g == "EWMA"
        if all(q0 == 0)
            q1 = S_t
        else
            q1 = eta*q0 + (1-eta)*((q0 .* S_t)/transpose(q0)*S_t)
        end
    end
    return q1
end

function ReNormAgMix(q0, absol)
    if absol == true
        q1= q0 / sum(q0)
    else
        absSum = sum(abs.(q0 - mean(q0)))
        if absSum > eps()
            q1 = (q0 - mean(q0)) / absSum
        else
            q1 = zeros(size(q0))
        end
        a = sum(abs.(q1))
    end
    return q1
end

function OnlineLearn(PortVal0, q0, b0, x, H0, H1, ExpertVal0, Rule_g, eta, absol)
    #Online Learning algorithm for 1 time period

    #PortVal is Total Portfolio Value (scalar)
    #b is the portfolio controls at the start of the period (vector Mx1)
    #x is the price relatives for the current period (vector 1xM)
    #H_curr is the agent controls matrix for the current period (Matrix NxM)
    #H_next is the agent controls matrix for the next period (Matrix NxM)
    #AgentVal the portfolio value of each agent (vector Nx1) (how much each agent has when the function is called)

    #Update portfolio wealth
    PortVal1 = PortVal0 * (transpose(x-1) * b0 + 1)

    #Update Agent Wealth
    ExpertVal1 = ExpertVal0 .* ((H0 * (x-1)) + 1)

    #Update q
    q1 = OnlineFunction(Rule_g, q0, ExpertVal1, eta)

    q1 = ReNormAgMix(q1, absol)

    #Update Portfolio controls
    b1 = transpose(H1) * q1

    #leverage corrections
    v = sum(abs.(b1))
    if v > eps()
        b1 = 1/v * b1
        q1 = 1/v *q1
    end
    return b1,ExpertVal1, PortVal1, q1

end

function OnlineZBCRP(X, k, Anti)
    #No Matches
    #Anti-BCRP will be the same but with negative mu
    # k >= 2? Is this fine? Must I make consideration for if k = 1
    # t-k or t-k+1??
    #calculate mean and covariance

    #covariance, check condition number, if too big, use diag of variances
    #consider using shrinkage parameter

    #return vector matrix of agent controls
    M = size(X)[2]
    onesM = ones(M)

    #1
    #update agent tuple
    #ag_tup = map(x -> parse(Float64, x), X[end-k+1:end,1:end])-1
    exp_tup = X-1
    if Anti == false
        mu = transpose(mapslices(mean, exp_tup, [1]))
    else
        mu = - transpose(mapslices(mean, exp_tup, [1]))
    end
    if k == 1
        sigma = eye(M)
        inv_sigma = sigma
    else
        sigma = cov(exp_tup)
        #if log(CondMat) < 16 && size(exp_tup)[1] > size(exp_tup)[2]
        if cond(sigma) < (1/1e-2) && k > M
            inv_sigma = inv(sigma)
        else
            sigma = diagm(diag(sigma))
            if cond(sigma) > 1/1e-2
                sigma = eye(M)
            end
            inv_sigma = inv(sigma)
        end
    end

    sigma_scale = transpose(onesM)*inv_sigma*onesM
    risk_aver = transpose(abs.((inv_sigma*(mu*transpose(onesM) - onesM*transpose(mu))*inv_sigma*onesM)/sigma_scale))*onesM
    exp_cont = inv_sigma/risk_aver *((mu*transpose(onesM) - onesM*transpose(mu))/(sigma_scale))*inv_sigma*onesM
    #2
    return exp_cont
end

function ExpAlg(W, X, K, T, H0)
    if W == 1
        return OnlineZBCRP(X, K, false)
    elseif W == 2
        return OnlineZBCRP(X, K, true)
    elseif W == 3
        return OnlineZAntiCor(X, K, T, H0)
    end
end


function Exp_Gen(K, L, W, M, stocks, H0)
    #ag_gen generates kxl agents all using the ag_alg algorithm to determine
    #their portfolios, time might need to be implemented???
    #ag_alg is a string for the portfolio algorithm to be followed
    #k is the size of the window to include
    #l is an algorithm specific parameter
    #stocks is matrix of all price relatives up until the current time
    L = 1
    #N = sum(K)*L
    T = size(stocks)[1]
    H_mat = Matrix((K*L*W),M)

    for w in 1:W
        for l in 1:L
            for k in 1:K
                mat_ind = ((w-1)*L*K+(l-1)*K+k)
                    if w == 3
                        H_mat[mat_ind,:] = ExpAlg(w, stocks[(end - min(2*k, T) +1 : end),:], min(k, T), T, H0[mat_ind,:])
                    else
                        H_mat[mat_ind,:] = ExpAlg(w, stocks[(end - min(k, T) +1 : end),:], min(k, T), H0[k,:])
                    end
            end
        end
    end
    return H_mat
end

function Simulation(start_date, end_date, date_vec, X, K, L, W, eta, Learn_Alg, absPort)
    L = 1
    start_ind = find(date_vec .== start_date)[1]
    end_ind = find(date_vec .== end_date)[1]
    T = end_ind - start_ind
    X = X[start_ind+1:end_ind, :] #price relatives, therefore first price relative is only available at t=2
    M = size(X)[2]
    N = K * L * W

    #begin at time 0 with uniform portfolio
    q_mat = Matrix(N,T)
    b_mat = Matrix(M,T)

    Snt_mat = Matrix(N,T+1)

    St_vec = Vector(T+1)
    St_vec[1] = 1

    q_mat[:,1] = zeros(N)

    #b = ones(M) ./ M
    b_mat[:, 1] = zeros(M)

    Snt_mat[:,1] = ones(N)

    H0 = Matrix(N,M) .= 0

    for t in 2:T
        H1 = Exp_Gen(K, L, W, M, X[1:t-1,:], H0)
        b_mat[: , t], Snt_mat[:, t], St_vec[t], q_mat[:, t] = OnlineLearn(St_vec[t-1], q_mat[:, t-1], b_mat[:, t-1], X[t-1,:], H0, H1, Snt_mat[:, t-1], Learn_Alg, eta, absPort)
        H0 = H1
    end
    St_vec[end] = St_vec[end-1] * (transpose(X[end,:]-1) * b_mat[:, end] + 1)
    Snt_mat[:, end] = Snt_mat[:, end-1] .* ((H0 * (X[end,:]-1)) + 1)
    return b_mat, q_mat, Snt_mat, St_vec
end

b_test, q_test, Snt_test, St_test =Simulation("19620703", u , StockDates, StockHist, 5,1, 3, 0.01,"Uni", false)
function Simulation(start_date, end_date, date_vec, X, K, L, W, eta, Learn_Alg, absPort)

u = StockDates[3]
u = StockDates[20]
u = StockDates[10951]

sum(b_test[:,18])
sum(q_test[:9])


Snt_test[11:15,6:10]
q_test[11:15,:]
using Plots

start_ind = find(StockDates .== "19620703")[1]
end_ind = find(StockDates .== u)[1]

plotDates = StockDates[start_ind : end_ind]
gr()
plot(plotDates, St_test, title = "Portfolio Value over Time", label = "test", lw = 2)

a = Vector{String}(101) .= ""
a[end-100:10:end] = plotDates[end-100:10:end]
a


function OnlineZAntiCor(X, K, T, H0) #active only atm, no transfers
    M = size(X)[2]
    if T < 2*K
        H1 = H0
    else
        LX1 = log.(X[end-2*K+1:end-K,:])
        LX2 = log.(X[end-K+1:end,:])
        mu1 = mapslices(mean, LX1, [1])
        mu2 = mapslices(mean, LX2, [1])
        claims = Matrix(M,M) .= 0
        H1 = Vector{Float64}(M)
        if K > 1
            sigma1 = transpose(mapslices(std, LX1, [1]))
            sigma2 = transpose(mapslices(std, LX2, [1]))
            M_cov = (1/(K-1)) * (transpose(LX1-(ones(K)*mu1))) * (LX2-(ones(K)*mu2))
            M_cor = M_cov ./ (sigma1 * transpose(sigma2))
            M_cor[find(isnan.(M_cor))] = 0 #filter! might be faster?

            for j in 1:M
                claims[:,j] = Claim(j, M_cor[:,j], diag(M_cor), M, claims[:,j], mu2)
            end
        else
            sigma1 = zeros(M)
            sigma2 = zeros(M)
            M_cov = zeros(M,M)
            M_cor = ones(M,M)

            claims .= -1 #CHECK
        end
        for i in 1:M
            H1[i] = H0[i] + 1/3*(sum(claims[:,i] - claims[i,:]))
        end
    end
    #normalize to long short unit leverage
    H1 = ReNormAgMix(H1, false)
    return H1
end

function Claim(j, Mcorj, McorDiag, M, Claimj, mu)
    for i in 1:M
        if mu[i] >= mu[j] && Mcorj[i] > 0
            Claimj[i] = Mcorj[i] + max(0, -McorDiag[i]) + max(0, -McorDiag[j])
        end
    end
    return Claimj
end



a = Matrix(4,4) .= 4

a = Vector(4) .= 1

a = Snt_test[12, 6:10]
