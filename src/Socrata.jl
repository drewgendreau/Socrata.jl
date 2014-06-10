module Socrata
    
export socrataget, 
       socrata
       

using Requests, DataFrames


include("api.jl")
include("socratatools.jl")
include("dataframe.jl")

end