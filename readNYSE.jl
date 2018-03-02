using CSV

function ReadInNYSE(sDir::String)
    files_list = readdir(sDir)
    filter!(x -> !(x in ["Bond.csv", "Cash.csv"]), files_list)
    arrDates = ReadStockDates(sDir*"\\"*files_list[1])
    arrStocks = ReadStockCSV(sDir*"\\"*files_list[1])
    arrTickers = replace.(files_list, ".csv", "")
    filter!(x -> x != "Cash" || x != "Bond", arrTickers)
    for file in files_list[2:end]
        arrStocks = hcat(arrStocks, ReadStockCSV(sDir*"\\"*file))
    end
    return arrTickers, arrDates, arrStocks
end

function ReadStockCSV(sFile_path::String)
    return CSV.read(sFile_path ; delim = ',', header = ["Dates", "PR"])[:,2]
end

function ReadStockDates(sFile_path::String)
    arrInput = string.(CSV.read(sFile_path; delim = ',', header = ["Dates","PR"])[:,1])
    arrOutput = Array{String}(0)
    for line in arrInput
        if length(line) == 6
            line = "19" * line
        elseif length(line) == 5
            line = "200" * line
        elseif length(line) == 4
            line = "2000" * line
        else
            line = "20000" * line
        end
        arrOutput = vcat(arrOutput, line)
    end
    return arrOutput
end


Tickers, StockDates, StockHist = ReadInNYSE("C:\\Users\\Michael\\Documents\\UCT 2017\\Honours Project\\Testing\\data\\NYSE")

StockDates[9444]






#files_list = readdir("C:\\Users\\Michael\\Documents\\UCT 2017\\Honours Project\\Testing\\data")
