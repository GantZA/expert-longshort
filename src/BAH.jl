function BuyAndHold(Stocks)
    T, M = size(Stocks)
    St = Matrix(M, T+1)
    log_Stocks = Matrix(T,M)
    log_Stocks[:,:] .= Stocks
    St[:,1] = zeros(M)
    for i in 1:T
        log_Stocks[i,:] = log.(log_Stocks[i,:])
        St[:,i+1] = St[:,i] + log_Stocks[i,:]
    end
    return exp.(St)
end

function UBuyAndHold(Stocks)
    T, M = size(Stocks)
    St = Matrix(M, T+1)
    log_Stocks = Matrix(T,M)
    log_Stocks[:,:] .= Stocks
    St[:,1] = ones(M)/M
    for i in 1:T
        St[:,i+1] = St[:,i] .* log_Stocks[i,:]
    end
    return St
end

a1 = BuyAndHold(JSE_Stocks[1:5823,:])
a2 = UBuyAndHold(JSE_Stocks[1:5823,:])
sum(a2[:,end])
a1 = ones(36)' * a2

print(a1[:,end])
print(JSE_Tickers)

using Plots
plotly()
plot(JSE_Dates, a1', xticks = (1:750:5823, JSE_Dates[1:750:5823]))
plot(JSE_Dates, a2', xticks = (1:750:5823, JSE_Dates[1:750:5823]))
sum(a2[:,end])
print(b_JSE2[:,end])
a1[4,end]

a3 = UBuyAndHold(JSE_ALSHI_PR[1:end,:])
a4 = BuyAndHold(JSE_ALSHI_PR[1:end,:])
function ALSH_BAH(Stocks)
    T, M = size(Stocks)
    St = Matrix(M, T+1)
    log_Stocks = Matrix(T,M)
    log_Stocks[:,:] .= Stocks
    St[:,1] = ones(M)/M
    for i in 1:T
        St[:,i+1] = St[:,i] .* log_Stocks[i,:]
    end
    return St

end
