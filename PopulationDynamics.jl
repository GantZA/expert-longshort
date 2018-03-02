function ExpRelPop(S_nt, S_ind)
    T = size(S_nt)[2]
    y_t = Matrix{Float64}(T,3)
    for i in 1:T
        y_t[i,:] = [sum(S_nt[1:S_ind[1],i]) ,
        sum(S_nt[(S_ind[1]+1):S_ind[2],i]),
        sum(S_nt[(S_ind[2]+1):end,i])] / sum(S_nt[:,i])
    end
    return y_t
end
