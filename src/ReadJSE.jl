using CSV
ab
function ReadInJSE(sDir::String)
    sFile = "C:\\Users\\Michael\\Documents\\UCT 2017\\Honours Project\\Testing\\data" * sDir
    return CSV.read(sFile; delim = ';')
end



JSEData = ReadInJSE("\\JSE_TOP_19942017_002.csv")
JSEALSHI = ReadInJSE("\\JSE_ALSHI.csv")

JSE_Tickers = string.(names(JSEData)[2:end])
JSE_Stocks = convert(Array,JSEData[end:-1:1,2:end])
JSE_Dates = convert(Array,JSEData[end:-1:1,1])

JSE_Stocks[JSE_Stocks .>= 1.3] = 1
JSE_Stocks[JSE_Stocks .<= 0.7] = 1


JSE_ALSHI_PR = convert(Array,JSEALSHI[end:-1:1,2])
JSE_ALSHI_Dates = convert(Array,JSEALSHI[end:-1:1,1])
