print(JSE_Tickers)

#UNI LS NOM
b_JSE, q_JSE, PLt_JSE, PLnt_JSE, H_JSE = Simulation(true,s,
 u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"Uni", false, false)



#EWMA LS NOM
 b_JSE1, q_JSE1, PLt_JSE1, PLnt_JSE1, H_JSE1 = Simulation(true,s,
    u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.1,"EWMA", false, false)

#UNI LO NOM
b_JSE2, q_JSE2, PLt_JSE2, PLnt_JSE2, H_JSE2 =Simulation(true,s,
u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"Uni", true, true)

#EWMA LO NOM
b_JSE3, q_JSE3, PLt_JSE3, PLnt_JSE3, H_JSE3 = Simulation(true,s,
 u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"EWMA", true, true)

#UNI LS COM
 b_JSE4, q_JSE4, PLt_JSE4, PLnt_JSE4, H_JSE4 =Simulation_Comp(true,s,
  u , JSE_Dates, JSE_Stocks, [5,5,5], [1, 3], 0.01,"Uni", false, false)














#ANG vs AGL
ANG_AGLind = [1,2]
b_t1, q_t1, PLt_t1, PLnt_t1, H_t1 =@enter Simulation(true,s,
 u , JSE_Dates, JSE_Stocks[:,ANG_AGLind], [5,5,5], [1, 3], 0.01,"Uni", false, false)


#TBS vs WHL
TBS_WHLind = [28,34]
b_t2, q_t2, PLt_t2, PLnt_t2, H_t2 =Simulation(true,s,
 u , JSE_Dates, JSE_Stocks[:,TBS_WHLind], [5,5,5], [1, 3], 0.01,"Uni", false, false)


#SBK vs FSR
FSR_SBKind = [14,22]
b_t3, q_t3, PLt_t3, PLnt_t3, H_t3 =Simulation(true,s,
 u , JSE_Dates, JSE_Stocks[:,FSR_SBKind], [5,5,5], [1, 3], 0.01,"Uni", false, false)
