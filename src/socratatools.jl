# helper functions for Socrata.jl

function checkIDValidity(ID::String)
    if length(ID) != 9
        return false
    elseif ismatch(r"^[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}$", ID) == false
        return false
    end

    return true
end


function fullURL(url::String)

    # Get the domain
    temp_url = split(url, r"https?://")[2]
    domain = split(temp_url, "/")[1]

    # Get the 4x4 and test it
    socrata_id = split(temp_url, "/")[end]
    if length(socrata_id) < 9
        error("Error re-building URL: invalid 4x4 ID length")
    else
        socrata_id = socrata_id[1:9]
    end

    if checkIDValidity(socrata_id) == false
        error("Error re-building URL: invalid 4x4 ID")
    end

    # Build up the new URL and add options limit/offset options
    return_url = *("https://$domain/api/views/$socrata_id",
                    "/rows.csv?accessType=DOWNLOAD")

    return return_url

end

function partialURL(url::String, query_args)

    # Get the domain
    temp_url = split(url, r"https?://")[2]
    domain = split(temp_url, "/")[1]

    # Get the 4x4 and test it
    socrata_id = split(temp_url, "/")[end]

    if length(socrata_id) < 9
        error("Error re-building URL: invalid 4x4 ID length")
    else
        socrata_id = socrata_id[1:9]
    end

    if checkIDValidity(socrata_id) == false
        error("Error re-building URL: invalid 4x4 ID")
    end

    # Build up the new URL and add options limit/offset options
    return_url = *("https://$domain/resource/$socrata_id.csv?")
                    

    for i in keys(query_args)
        str_insert = get(query_args, i, "")
        if str_insert != ""
            if i == "app_token"
                return_url = *(return_url, "\$\$$i=$str_insert")
            else
                return_url = *(return_url, "&\$$i=$str_insert")
            end
        end
    end

    println(return_url)

    return return_url
end

function changeLimitOffset(url::String, limit::Integer, offset::Integer)
    # changes the limit and offset values in the URL to those passed

    limit = string(limit)
    offset = string(offset)

    return_url = replace(url, r"limit=([0-9]+)?", *("limit=$limit"))
    return_url = replace(return_url, r"offset=([0-9]+)?", *("offset=$offset"))

    return return_url

end

# TODO: add auth_token functionality

# function set_auth_token(token::String)

#     # TODO: Verify if the token is valid
#     token_file = open(Pkg.dir("Socrata/src/token/auth_token.jl"), "w")

#     try
#         write(token_file, token * "\n") # Put a newline after the token
#     finally
#         close(token_file)
#     end

#     return nothing
# end