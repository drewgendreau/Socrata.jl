using DataFrames

module Socrata
    
export socrata       

using Requests, DataFrames


include("api.jl")
include("socratatools.jl")
include("dataframe.jl")

end