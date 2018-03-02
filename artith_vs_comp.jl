function Arith(S,R,T)
    S_t = Vector(T+1)
    S_t[1] = S
    for t in 1:T
        S_t[t+1] = S_t[t] + R*S
    end
    return S_t
end

function Comp(S,R,T)
    S_t = Vector(T+1)
    S_t[1] = S
    for t in 1:T
        S_t[t+1] = S_t[t] * (1+R)
    end
    return S_t
end

A = Arith(1,0.05,1000)
B = Comp(1,0.05,1000)
plot(1:1001, A)

using JLD

@save "myfile.jld"
