include("Simulation.jl")
include("readNYSE.jl")
include("ReadNYSE_Cover.jl")
include("OnlineLearn.jl")
include("ZBCRP.jl")
include("ZAntiCor.jl")
include("ReadJSE.jl")


b_test, q_test, Snt_test, St_test, H_test = Simulation(true,"19620703",
 u , StockDates, StockHist, [5,5,5],1, [1, 1], 0.01,"Uni", true, true)


u = StockDates[5]
u = StockDates[50]
u = StockDates[500]
u = StockDates[10951]

#NYSE Merged Data
#Simulation Parameters
# IndexByDate, start_date, end_date, date_vec, X, K, L, W, eta, Learn_Alg, absPort, absExp)
#Active Experts, Long-Short Aggregate Portfolio
b_NYSE, q_NYSE, PLt_NYSE, PLnt_NYSE, H_NYSE = Simulation(true,"19620703",
 u , StockDates, StockHist, [5,5,5], [1, 3], 0.01,"Uni", false, false)

 b_NYSE, q_NYSE, Snt_NYSE, St_NYSE, H_NYSE = Simulation(true,"19620703",
  u , StockDates, StockHist, [5,5,5],1, [1, 3], 0.01,"EG", false, false)

  b_NYSE1, q_NYSE1, Snt_NYSE1, St_NYSE1, H_NYSE1 = Simulation(true,"19620703",
   u , StockDates, StockHist, [5,5,5], [1, 3], 0.9,"EWMA", false, false)

u = StockDates[10951]

find(x->x<0,JSE_Stocks[1,:])
JSE_Stocks[1,21]


#Active Experts, Long only Aggregate Portfolio
#not possible

#Absolute Experts, Long-Short Aggregate Portfolio
b_NYSE, q_NYSE, Snt_NYSE, St_NYSE, H_NYSE = Simulation(true,"19620703",
 u , StockDates, StockHist, [5,5,5],1, [1, 3], 0.01,"Uni", false, true)

#Absolute Experts, Long only Aggregate Portfolio
b_NYSE, q_NYSE, Snt_NYSE, St_NYSE, H_NYSE = Simulation(true,"19620703",
 u , StockDates, StockHist, [5,5,5],1, [1, 3], 0.01,"Uni", true, true)


#portfolios in NYSE Cover

b_Cover, q_Cover, PLt_Cover, PLnt_Cover, H_Cover = Simulation(false,1,
 5651 , StockDates, NYSE_Cover, [5,5,5], [1, 3], 0.01,"Uni", false, false)

b_Cover, q_Cover, Snt_Cover, St_Cover, H_Cover = Simulation(false,1,
  5651 , StockDates, NYSE_Cover, [5,5,5],1, [1, 3], 0.01,"EG", false, false)

b_Cover1, q_Cover1, Snt_Cover1, St_Cover1, H_Cover1 = Simulation(false,1,
   5651 , StockDates, NYSE_Cover, [5,5,5],1, [1, 3], 0.9,"EWMA", false, false)

St_test[2:end] ./ St_test[1:end-1]

#Portfolios in JSE

b_JSE, q_JSE, PLt_JSE, PLnt_JSE, H_JSE = Simulation(true,s,
 u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"Uni", false, false)

 b_JSE4, q_JSE4, PLt_JSE4, PLnt_JSE4, H_JSE4 =Simulation_Comp(true,s,
  u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"Uni", false, false)

 b_JSE2, q_JSE2, PLt_JSE2, PLnt_JSE2, H_JSE2 =Simulation(true,s,
  u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"Uni", true, true)

  b_JSE3, q_JSE3, PLt_JSE3, PLnt_JSE3, H_JSE3 = Simulation(true,s,
   u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"EWMA", true, true)

b_JSE, q_JSE, PLt_JSE, PLnt_JSE, H_JSE = Simulation(true,s,
  u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"EG", false, false)

b_JSE1, q_JSE1, PLt_JSE1, PLnt_JSE1, H_JSE1 = Simulation(true,s,
   u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.1,"EWMA", false, false)


u = JSE_Dates[5823]
u = JSE_Dates[20]

s = JSE_Dates[1]
PLt_JSE[175]
JSE_Stocks[1:180,32]
Snt_JSE[:,1800]
H_JSE[75][:,32]
JSE_Stocks[1610,:]
JSE_Dates[3840]
a =find(x->x=="NPN",JSE_Tickers)

using Plots
plotly()
plot(JSE_Dates, PLt_JSE, xticks = (1:750:5823, JSE_Dates[1:750:5823]),
label = "Runnning Total Aggregate Portfolio")
plot(1:5651, PLt_Cover, xticks = (1:750:5651, 1:750:5651),
label = "Runnning Total Aggregate Portfolio")
plot(StockDates[1:10951], PLt_NYSE, xticks = (1:1500:10951,
StockDates[1:1500:10951]), label = "Runnning Total Aggregate Portfolio")
St_JSE[220:300]

plot(JSE_Dates, PLnt_JSE2', xticks = (1:750:5823, JSE_Dates[1:750:5823]),
label = "Runnning Total Aggregate Portfolio")

plot(StockDates[1:10951], PLnt_NYSE', xticks = (1:1500:10951,
StockDates[1:1500:10951]),
label = "Runnning Total Aggregate Portfolio")


#ZUNI
b_JSE, q_JSE, PLt_JSE, PLnt_JSE, H_JSE = Simulation(true,JSE_Dates[1],
 JSE_Dates[5823] , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0,"Uni", false, false)

b_JSE1, q_JSE1, PLt_JSE1, PLnt_JSE1, H_JSE1 = Simulation(true,JSE_Dates[1],
  JSE_Dates[5823] , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0,"Uni", true, true)


#ZEWMA

b_JSE3, q_JSE3, PLt_JSE3, PLnt_JSE3, H_JSE3 = Simulation(true, JSE_Dates[1],
 JSE_Dates[5823], JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.5,"EWMA", false, false)

b_JSE1, q_JSE1, PLt_JSE1, PLnt_JSE1, H_JSE1 = Simulation(true,JSE_Dates[1],
  JSE_Dates[5823] , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0,"Uni", true, true)

b_JSE2, q_JSE2, PLt_JSE2, PLnt_JSE2, H_JSE2 = Simulation(true, JSE_Dates[1],
  JSE_Dates[5823], JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.5,"EWMA", true, true)

plot(JSE_Dates, PLt_JSE, xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "Zero Cost Universal Portfolio Value", title = "Investing on 36 JSE Assets")
plot!(JSE_Dates, PLt_JSE3, xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "Zero Cost EWMA Portfolio Value")
plot!(JSE_Dates, PLt_JSE1, xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "Long-Only Universal Portfolio Value")
plot!(JSE_Dates, PLt_JSE2, xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "Long-Only EWMA Portfolio Value")


#Cover

#ZUNI
b_Cover, q_Cover, PLt_Cover, PLnt_Cover, H_Cover = Simulation(false,1,
5651 , 0, NYSE_Cover, [5,5,5], [1, 3], 0,"Uni", false, false)

b_Cover1, q_Cover1, PLt_Cover1, PLnt_Cover1, H_Cover1 = Simulation(false,1,
  5651 , 0,  NYSE_Cover, [5,5,5], [1, 3], 0,"Uni", true, true)


#ZEWMA

b_Cover3, q_Cover3, PLt_Cover3, PLnt_Cover3, H_Cover3 = Simulation(false, 1,
 5651, 0, NYSE_Cover, [5,5,5], [1, 3], 0.5,"EWMA", false, false)

b_Cover2, q_Cover2, PLt_Cover2, PLnt_Cover2, H_Cover2 = Simulation(false, 1,
  5651, 0, NYSE_Cover, [5,5,5], [1, 3], 0.5,"EWMA", true, true)

PLt_Cover[[500,1000,1500,2000,2500]]
i = vcat(collect(1:11)*500,5651)

print(round.(PLt_Cover[i],3))
print(round.(PLt_Cover3[i],3))
print(round.(PLt_Cover1[i],3))
print(round.(PLt_Cover2[i],3))
using Plots
plotly()
plot(1:5651, PLt_Cover, xticks = (1:1000:5651, 1:1000:5651),
label = "Zero Cost Universal Portfolio Wealth", title = "Investing on 36 NYSE Stocks 199")
plot!(1:5651, PLt_Cover3, xticks = (1:1000:5651, 1:1000:5651),
label = "Zero Cost EWMA Portfolio Wealth")
plot!(1:5651, PLt_Cover1, xticks = (1:1000:5651, 1:1000:5651),
label = "Long-only Universal Portfolio Wealth")
plot!(1:5651, PLt_Cover2, xticks = (1:1000:5651, 1:1000:5651),
label = "Long-only EWMA Portfolio Wealth")


#Merged
b_NYSE, q_NYSE, St_NYSE, Snt_NYSE, H_NYSE = Simulation(true,"19620703",
 "20061124" , StockDates, StockHist, [5,5,5], [1, 3], 0,"Uni", false, false)

b_NYSE1, q_NYSE1, St_NYSE1, Snt_NYSE1, H_NYSE1 = Simulation(true,"19620703",
  "20061124" , StockDates, StockHist, [5,5,5], [1, 3], 0,"Uni", true, true)


#ZEWMA

b_NYSE2, q_NYSE2, St_NYSE2, Snt_NYSE2, H_NYSE2 = Simulation(true,"19620703",
 "20061124" , StockDates, StockHist, [5,5,5], [1, 3], 0.5,"EWMA", false, false)

b_NYSE3, q_NYSE3, St_NYSE3, Snt_NYSE3, H_NYSE3 = Simulation(true,"19620703",
  "20061124" , StockDates, StockHist, [5,5,5], [1, 3], 0.5,"EWMA", true, true)


print(StockDates[i])
i = vcat(collect(1:11)*1000,11178)
print(round.(St_NYSE[i],3))
print(round.(St_NYSE2[i],3))
print(round.(St_NYSE1[i],3))
print(round.(St_NYSE3[i],3))

plot(StockDates, St_NYSE, xticks = (1:1750:11178,
StockDates1[1:1750:11178]), label = "Zero Cost Universal Portfolio Wealth",
ylabel = "Portfolio Wealth", xlabel = "Date (yyyymmdd)", title = "Investing in 23 NYSE Merged Stocks 1962-2006")
plot!(StockDates, St_NYSE2, label = "Zero Cost EWMA Portfolio Wealth")
plot!(StockDates, St_NYSE1,  label = "Long-only Universal Portfolio Wealth")
plot!(StockDates, St_NYSE3,  label = "Long-only EWMA Portfolio Wealth")



#JSE
#ZUNI
b_JSE, q_JSE, PLt_JSE, PLnt_JSE, H_JSE = Simulation(true,"1994/01/04",
 "2017/04/28" , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0,"Uni", false, false)


b_JSE1, q_JSE1, PLt_JSE1, PLnt_JSE1, H_JSE1 = Simulation(true,"1994/01/04",
  "2017/04/28" , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0,"Uni", true, true)

#ZEWMA
b_JSE2, q_JSE2, PLt_JSE2, PLnt_JSE2, H_JSE2 = Simulation(true,"1994/01/04",
   "2017/04/28" , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.5,"EWMA", false, false)


b_JSE3, q_JSE3, PLt_JSE3, PLnt_JSE3, H_JSE3 = Simulation(true,"1994/01/04",
    "2017/04/28" , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.5,"EWMA", true, true)


i = vcat(collect(1:11)*500,5823)
print(JSE_Dates[i])
print(round.(PLt_JSE[i],3))
print(round.(PLt_JSE2[i],3))
print(round.(PLt_JSE1[i],3))
print(round.(PLt_JSE3[i],3))


plot(JSE_Dates, PLt_JSE, xticks = (1:750:5823, JSE_Dates[1:750:5823]),
label = "Zero Cost Universal Portfolio Wealth",
ylabel = "Portfolio Wealth", xlabel = "Date (yyyy/mm/dd)", title = "Investing in 36 JSE Stocks 1994-2017")
plot!(JSE_Dates, PLt_JSE2, xticks = (1:750:5823, JSE_Dates[1:750:5823]),
label = "Zero Cost EWMA Portfolio Wealth")
plot!(JSE_Dates, PLt_JSE1, xticks = (1:750:5823, JSE_Dates[1:750:5823]),
label = "Long-only EWMA Portfolio Wealth")
plot!(JSE_Dates, PLt_JSE3, xticks = (1:750:5823, JSE_Dates[1:750:5823]),
label = "Zero Cost EWMA Portfolio Wealth")


RelativePop_JSE = ExpRelPop(PLnt_JSE, [5,10])

plot_y = [RelativePop_JSE[:,1]; RelativePop_JSE[:,2]; RelativePop_JSE[:,3]]
plot_x = [JSE_Dates ; JSE_Dates ; JSE_Dates]
group =  Vector()
group[1:5823], group[5824:11646] ,group[11647:end] = "ZBCRP","AntiZBCRP","ANTICOR"
RelativePop_JSE[:,1]
plot(JSE_Dates, RelativePop_JSE, xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = ["ZBCRP" "AntiZBCRP" "ZANTICOR"])

b = areaplot(x = plot_x, y = plot_y, group = group, stacked = true)

#JSE
RelativePop_JSE = ExpRelPop(PLnt_JSE, [5,10])*100
plot(JSE_Dates,RelativePop_JSE[:,1], fillrange = [zeros(5823) RelativePop_JSE[:,1]],
colour = "#1956e0", label = "ZBCRP",title = "<b>Relative Population Sizes of Active Experts (JSE)</b>",
xticks = (1:1000:5823, JSE_Dates[1:1000:5823]), ylabel = "<b>Relative Population </b>", xlabel = "<b>Date (yyyy/mm/dd) </b>")
plot!((RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), fillrange = [RelativePop_JSE[:,1],
RelativePop_JSE[:,2]], colour = "#80a0e8",label = "Anti-ZBCRP")
plot!(ones(5823)*100, fillrange = [(RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), ones(5823)*100],
 colour = "#b9c9ed", label = "ZANTICOR")

RelativePop_JSE = ExpRelPop(PLnt_JSE3, [5,10])*100
plot(JSE_Dates,RelativePop_JSE[:,1], fillrange = [zeros(5823) RelativePop_JSE[:,1]],
colour = "#1956e0", label = "BCRP",title = "<b>Relative Population Sizes of Absolute Experts (JSE)</b>",
xticks = (1:1000:5823, JSE_Dates[1:1000:5823]), ylabel = "<b>Relative Population </b>", xlabel = "<b>Date (yyyy/mm/dd) </b>")
plot!((RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), fillrange = [RelativePop_JSE[:,1],
RelativePop_JSE[:,2]], colour = "#80a0e8",label = "Anti-BCRP")
plot!(ones(5823)*100, fillrange = [(RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), ones(5823)*100],
colour = "#b9c9ed", label = "ANTICOR")


#NYSE Cover

RelativePop_JSE = ExpRelPop(PLnt_Cover, [5,10])*100
plot(RelativePop_JSE[:,1], fillrange = [zeros(5651) RelativePop_JSE[:,1]],
colour = "#1956e0", label = "ZBCRP",title = "<b>Relative Population Sizes of Active Experts (NYSE Cover)</b>",
xticks = (1:1000:5651, 1:1000:5651), ylabel = "<b>Relative Population </b>", xlabel = "<b>Date (yyyy/mm/dd) </b>")
plot!((RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), fillrange = [RelativePop_JSE[:,1],
RelativePop_JSE[:,2]], colour = "#80a0e8",label = "Anti-ZBCRP")
plot!(ones(5651)*100, fillrange = [(RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), ones(5651)*100],
 colour = "#b9c9ed", label = "ZANTICOR")

RelativePop_JSE = ExpRelPop(PLnt_Cover1, [5,10])*100
plot(RelativePop_JSE[:,1], fillrange = [zeros(5651) RelativePop_JSE[:,1]],
colour = "#1956e0", label = "BCRP",title = "<b>Relative Population Sizes of Absolute Experts (NYSE Cover)</b>",
xticks = (1:1000:5651, 1:1000:5651), ylabel = "<b>Relative Population (%) <b>", xlabel = "<b>Period </b>")
plot!((RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), fillrange = [RelativePop_JSE[:,1],
RelativePop_JSE[:,2]], colour = "#80a0e8",label = "Anti-BCRP")
plot!(ones(5651)*100, fillrange = [(RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), ones(5651)*100],
colour = "#b9c9ed", label = "ANTICOR")


#NYSE Merged

RelativePop_JSE = ExpRelPop(Snt_NYSE, [5,10])*100
plot(StockDates1,RelativePop_JSE[:,1], fillrange = [zeros(11178) RelativePop_JSE[:,1]],
colour = "#1956e0", label = "ZBCRP",title = "<b>Relative Population Sizes of Active Experts (NYSE Merged)</b>",
xticks = (1:1750:11178, StockDates1[1:1750:11178]), ylabel = "<b>Relative Population </b>", xlabel = "<b>Date (yyyy/mm/dd) </b>")
plot!((RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), fillrange = [RelativePop_JSE[:,1],
RelativePop_JSE[:,2]], colour = "#80a0e8",label = "Anti-ZBCRP")
plot!(ones(11178)*100, fillrange = [(RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), ones(11178)*100],
 colour = "#b9c9ed", label = "ZANTICOR")

RelativePop_JSE = ExpRelPop(Snt_NYSE3, [5,10])*100
plot(StockDates,RelativePop_JSE[:,1], fillrange = [zeros(11178) RelativePop_JSE[:,1]],
colour = "#1956e0", label = "BCRP",title = "<b>Relative Population Sizes of Absolute Experts (NYSE Merged)</b>",
xticks = (1:1750:11178, StockDates1[1:1750:11178]), ylabel = "<b>Relative Population </b>", xlabel = "<b>Date (yyyy/mm/dd) </b>")
plot!((RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), fillrange = [RelativePop_JSE[:,1],
RelativePop_JSE[:,2]], colour = "#80a0e8",label = "Anti-BCRP")
plot!(ones(11178)*100, fillrange = [(RelativePop_JSE[:,2]+RelativePop_JSE[:,1]), ones(11178)*100],
colour = "#b9c9ed", label = "ANTICOR")

StockDates1 = Vector(11178)
for i in 1:11178
 StockDates1[i] = StockDates[i][1:4] * "/" * StockDates[i][5:6] * "/" * StockDates[i][7:8]
end
StockDates1
