using Requests, DataFrames

module Socrata

using Requests, DataFrames

export socrataget, 
       socrata, 
       set_auth_token

include("api.jl")
include("socratatools.jl")
include("dataframe.jl")

end