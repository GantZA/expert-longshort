#Plots
#
using Plots
plotly()
#NYSE Merged
#Aggregate Portfolio Value vs Market vs Best Stock

#Expert Value (ALL)
plot(StockDates[1:10951], PLnt_NYSE', xticks = (1:1750:10951,
StockDates[1:1750:10951]), label = "Runnning Total Aggregate Portfolio",
ylabel = "Total Return", xlabel = "Date (yyyymmdd)", title = "NYSE Merged: Equity Curves for all experts")
#Expert Value (ZBCRP)
plot(StockDates[1:10951], PLnt_NYSE[1:5,:]', xticks = (1:1750:10951,
StockDates[1:1750:10951]), label = "Runnning Total Aggregate Portfolio")
#Expert Value (Anti-ZBCRP)
plot(StockDates[1:10951], PLnt_NYSE[6:10,:]', xticks = (1:1750:10951,
StockDates[1:1750:10951]), label = "Runnning Total Aggregate Portfolio")
#Expert Value (ANTICOR)
plot(StockDates[1:10951], PLnt_NYSE[11:15,:]', xticks = (1:1750:10951,
StockDates[1:1750:10951]), label = "Runnning Total Aggregate Portfolio")




#NYSE Cover


#JSE
plot(JSE_Dates, PLt_JSE, xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "Total Aggregate Portfolio Value", title = "Investing on 36 JSE Assets")

exp_labels = Matrix{String}(1,15)
exp_labels[1,:] .= "Expert " .* string.(collect(1:15))
plot(JSE_Dates, PLnt_JSE', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = exp_labels)

plot(JSE_Dates, PLnt_JSE[1:5,:]', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "ZBCRP " .* exp_labels)
plot(JSE_Dates, PLnt_JSE[6:10,:]', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "Anti-ZBCRP " .* exp_labels)
plot(JSE_Dates, PLnt_JSE[11:15,:]', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "ANTICOR " .* exp_labels)

plot(JSE_Dates, q_JSE', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = exp_labels)
plot(JSE_Dates, q_JSE[1:5,:]', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "ZBCRP " .* exp_labels)
plot(JSE_Dates, q_JSE[6:10,:]', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "Anti-ZBCRP " .* exp_labels)
plot(JSE_Dates, q_JSE[11:15,:]', xticks = (1:1000:5823, JSE_Dates[1:1000:5823]),
label = "ANTICOR " .* exp_labels)
