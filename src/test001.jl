#Notes
# I have not used L/ell parameter correctly. I thought it was a parameter for the learning algorithm
# but i am not too sure
# Now I think it is a partition parameter for selecting only certain Stocks
#not sure how to implement this.


function A(i)

end
#If I want global variables, I must declare constants
function OnlineAntiCor(LX1, LX2)
    #Need to finish Transfer part
    #dont globalise variables
    m = size(x)
    ones0 = ones(m)

    Mcov = 1/(w-1) * transpose(LX1 - ones0 * transpose(mu1)) * (LX2 - ones0 *transpose(mu2) )
    Mcor = Mcov / (sigma1 * transpose(sigma2))

    Claim = zeros(m,m)
    Transfer = zeros(m,m)
    for i = 1:m
        for j = 1:m
            if mu2[j] > mu2[i] && i != j #Dont think I need to check 2nd condition
                Claim[i,j] = Mcor[i,j] + A(i) + A(j)
            end
        end
    end


end

[1 1 0; 0 1 1 ; 1 1 1]*[1 1 0; 0 1 1 ; 1 1 1]

[1 1 0; 0 1 1 ; 1 1 1]

function OnlineFunction(g, q, S_t, eta)
    if g == "Uni"
        q_new = S_t
    elseif g == "EG"
        temp_sum = transpose(q)*S_t
        temp_exp = exp.((eta*S_t)/temp_sum)
        q_new = q .* temp_exp
    elseif g == "EWMA"
        temp_sum = transpose(q)*S_t
        q_new = eta*q + (1-eta)*(q .* S_t)
    end
    return q_new
end

function ReNormAgMix(q, absol)
    if absol == true
        q_new = q / sum(q)
    else
        q_temp = q - (1/size(q)[1])*sum(q)
        q_new = (q_temp) / sum(abs.(q_temp))
    end
    return q_new
end

a = [0.2;0.5;0.1;0.2]

b = a - (1/size(a)[1])*sum(a)
c = b / sum(abs.(b))

round(sum(a))


if round(sum(a)) == 1
    print("heh")
end



h = "EWMA"
OnlineFunction(h, q_1, S_t1, 0.5)


S_t1 = [1; 2; 4; 1; 2; 3; 4; 5]
q_1 = [0.1;0.1;0.1;0.1;0.1;0.2;0.2;0.1]

temp_sum1 = transpose(q_1)*S_t1
temp_exp1 = exp.((5*S_t1)/temp_sum1)
q_new1 = q_1 * temp_exp1

function OnlineLearn(PortVal, q, b, x, H_curr, H_next, AgentVal, ExpGenAlg, Rule_g, eta)
    #Online Learning algorithm for 1 time period

    #PortVal is Total Portfolio Value (scalar)
    #b is the portfolio controls at the start of the period (vector Mx1)
    #x is the price relatives for the current period (vector 1xM)
    #H_curr is the agent controls matrix for the current period (Matrix NxM)
    #H_next is the agent controls matrix for the next period (Matrix NxM)
    #AgentVal the portfolio value of each agent (vector Nx1) (how much each agent has when the function is called)

    #Update portfolio wealth
    PortVal_new = PortVal * (transpose(x-1) * b + 1)

    #Update Agent Wealth
    AgentVal_new = AgentVal .* ((H_curr * (x-1)) + 1)

    #Update q
    q_new = OnlineFunction(Rule_g, q, AgentVal_new, eta)
    #absolute agents
    #q_new = ReNormAgMix(q_new, true)

    #active agents
    q_new = @enter ReNormAgMix(q_new, false)

    #Update Portfolio controls
    b_new = transpose(H_next) * q_new

    #leverage corrections
    v = sum(abs.(b_new))
    b_new = 1/v * b_new
    q_new = 1/v * q_new


    return b_new, AgentVal_new, PortVal_new, q_new

end

PortVal, q, b, x, H_curr, H_next, AgentVal, ExpGenAlg, Rule_g

AgentVal_new = AgentVal .* ((H_curr * transpose(x-1)) + 1)

AgentVal = [1.5;2;1]
H_curr = [0.5 -0.25 -0.25; 0.5 -0.35 -0.15; 0.4 0.1 -0.5]
x = [1.05 1.4 0.8]


b_new = [0.4;0.5;-0.2;0.1;-0.8]
OnesM = ones(size(b_new))


b_new + 1


function OnlineBCRP(X, k)
    #No Matches
    #Anti-BCRP will be the same but with negative mu
    # k >= 2? Is this fine? Must I make consideration for if k = 1
    # t-k or t-k+1??
    #calculate mean and covariance

    #covariance, check condition number, if too big, use diag of variances
    #consider using shrinkage parameter

    #return vector matrix of agent controls

    onesM = ones(size(X[1,:]))

    #1
    #update agent tuple
    #ag_tup = map(x -> parse(Float64, x), X[end-k+1:end,1:end])-1
    ag_tup = X[end-k+1:end,1:end]-1
    mu = transpose(mapslices(mean, ag_tup, [1]))
    sigma = cov(ag_tup)
    inv_sigma = pinv(sigma)
    sigma_scale = transpose(onesM)*inv_sigma*onesM

    risk_aver = transpose(abs.((inv_sigma*(mu*transpose(onesM) - onesM*transpose(mu))*inv_sigma*onesM)/sigma_scale))*onesM

    ag_cont = inv_sigma/risk_aver *((mu*transpose(onesM) - onesM*transpose(mu))/(sigma_scale))*inv_sigma*onesM
    #2
    return ag_cont
end

@btime a = OnlineBCRP(StockHist, 100)


function Ag_Gen(ag_alg, K, L, M, stocks)
    #ag_gen generates kxl agents all using the ag_alg algorithm to determine
    #their portfolios, time might need to be implemented???
    #ag_alg is a string for the portfolio algorithm to be followed
    #k is the size of the window to include
    #l is an algorithm specific parameter
    #stocks is matrix of all price relatives up until the current time
    L = 1
    T = size(stocks)[1]
    if ag_alg == "BCRP"
        H_mat = Matrix((K*L),M)
        for l in 1:L
            for k in 2:K+1
                H_mat[(l-1)*K+k-1,:] = OnlineBCRP(stocks, min(k, T))
            end
        end
        return H_mat
    end
end

5 % 3

@btime ag_gen("BCRP",500,1, 25,StockHist)

a = Ag_Gen("BCRP",100,1, 25,StockHist)

H_mat_test = Matrix(25,10) .= 2
H_mat_test .= 1
size(H_mat_test)[1]
H_mat_test[:,1] = OnlineBCRP(StockHist, 2)
a = OnlineBCRP(StockHist, 10)
H_mat_test
#bucket shop
tradebook bloomberg

function Simulation(start_date, end_date, date_vec, X, K, L, eta, Learn_Alg, AgGen_Alg)
    L = 1
    start_ind = find(date_vec .== start_date)[1]
    end_ind = find(date_vec .== end_date)[1]
    T = end_ind - start_ind
    X = X[start_ind:end_ind, :]
    M = size(X)[2]
    N = K * L

    #begin at time 0 with uniform portfolio
    q_mat = Matrix(N,T)
    b_mat = Matrix(M,T)

    Snt_mat = Matrix(N,T+1)

    St_vec = Vector(T+1)
    St_vec[1] = 1

    q_mat[:,1] = ones(N)
    #q_mat[:,1] = zeros(N)

    #b = ones(M) ./ M
    b_mat[:, 1] = zeros(M)

    Snt_mat[:,1] = ones(N)

    H_mat = Matrix(N,M) .= 0

    for t in 2:T
        H_Next = Ag_Gen(AgGen_Alg, K, L, M, X[1:t,:])
        b_mat[: , t], Snt_mat[:, t], St_vec[t], q_mat[:, t] = OnlineLearn(St_vec[t-1], q_mat[:, t-1], b_mat[:, t-1], X[t,:], H_mat, H_Next, Snt_mat[:, t-1], AgGen_Alg, Learn_Alg, eta)
        H_mat = H_Next
    end
        St_vec[end] = St_vec[T] * (transpose(X[T+1,:]-1) * b_mat[:, T] + 1)
        Snt_mat[:, end] = Snt_mat[:, end-1] .* ((H_mat * (X[T+1,:]-1)) + 1)
    return b_mat, q_mat, Snt_mat, St_vec
end

function Simulation(start_date, end_date, date_vec, X, K, L, Learn_Alg, AgGen_Alg)

@enter Simulation("19620703", "19620807", StockDates, StockHist, 3, 2, 0.01,"Uni", "BCRP")
b_test, q_test, Snt_test, St_test =Simulation("19620703", w , StockDates, StockHist, 30,1, 0.01,"Uni", "BCRP")


w = StockDates[1000]

using BenchmarkTools


sum(b_test[:,500])
sum(q_test[:,2])




function diffVec(S)
    return (S[2:end] - S[1:end-1]) ./ S[1:end-1]
end
b = diffVec(St_test)
c = StockDates[99]

start_ind = find(StockDates .== "19620703")[1]
end_ind = find(StockDates .== a)[1]

plotDates = StockDates[start_ind+1:end_ind]

using Plots

for i in 1:25
    plot(StockDates[1:100], StockHist[1:100,i])
end
function PrepDates(Stock_dates, k)


end

function KRemain(element, ind, remain)

end

plot(StockDates[:], StockHist[:,1])

sum(b_test[:,])
