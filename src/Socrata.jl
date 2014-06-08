using Requests, DataFrames

module Socrata

export socrataget, 
       socrata
       
include("api.jl")
include("socratatools.jl")
include("dataframe.jl")

end