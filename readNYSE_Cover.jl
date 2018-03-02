using CSV

function ReadInNYSE_Cover(sDir::String)
    return CSV.read(sDir; delim = ' ')
end

NYSE_Cover = convert(Array,
ReadInNYSE_Cover("C:\\Users\\Michael\\Documents\\UCT 2017\\Honours Project\\data do not share\\NYSE Cover\\NYSE_Cover.csv"))
