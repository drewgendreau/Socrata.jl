# Helper functions for Socrata.jl

function checkIDValidity(ID::String)
    # Checks to make sure the passed 4x4 Socrata ID is valid

    if length(ID) != 9
        return false
    elseif ismatch(r"^[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}$", ID) == false
        return false
    end

    return true
end


function createURL(url::String, fulldataset::Bool)
    # Creates a valid URL to pass to GET
    
    # split the inital URL
    temp_url = split(url, r"https?://")[2]


    # Get the domain and 4x4 id and test it
    domain = split(temp_url, "/")[1]
    socrata_id = split(temp_url, "/")[end][1:9]

    if checkIDValidity(socrata_id) == false
        error("Error re-building URL: invalid 4x4 ID")
    end

    # Build the new URL using domain and socrata_id
    if fulldataset == true
        # if fulldataset == true, this means the user wants a full data set
        # and we ignore all query parameters
        
        return_url = *("https://$domain/api/views/$socrata_id",
                       "/rows.csv?accessType=DOWNLOAD")
    else
        # if fulldataset == false, this means we are using a partial data set
        # with the limit parameter set to something (defaults to 1000)
        # and will also use any query_args specified by the user

        return_url = "https://$domain/resource/$socrata_id.csv?"
    end

    return return_url

end


function checkErrors(response)
    # Check for common errors
    # TODO: Will probably add to this over time

    if response.status == 400
        msg = parse(response.data)
        error("Error: ", msg.args[3].args[2])
    elseif response.status == 404
        error("Error 404: Dataset Not Found. Check URL?")
    elseif contains(chomp(response.data), "\n") == false
        error("Error: Empty dataset")
    end

end


# TODO: Need to wait for Socrata to fix bug with CSV headers before implementing this

# function getFieldIDs(url, fulldataset, header_args)
#     # Gets field IDs from data and returns them as a vector of symbols

#     if fulldataset == true
#         url = replace(url, "api/views", "resource")
#         url = replace(url, "/rows.csv?accessType=DOWNLOAD", ".xml?")
#     else
#         url = replace(url, ".csv", ".xml")
#     end

#     println("URL: ", url)

#     # Just pull one row of data in XML
#     query_args = {"\$limit" => "1", "\$select" => "*"}
#     response = get(url, headers = header_args, query = query_args)

#     #println("Response.data: ")
#     println(response.data)

#     # Create vector of field names (XML nodes, children)   
#     fieldvec = matchall(r"[<][^/]*?[>]", response.data)

#     # Remove <response>, <row>, <, and > from each element 
#     filter!(x -> !ismatch(r"(<response>|<row>)", x), fieldvec)
#     fieldvec = map(x -> replace(x, r"[<>]", ""), fieldvec)

#     # Convert each element from string to symbol
#     fieldvec = map(symbol, fieldvec)

#     return fieldvec

# end


function getPagedData(url, header_args, query_args)

    # TODO: what happens if a data request is completely empty?

    # init an empty return value
    write_data = utf8("")
 
    # set some initial parameters
    total_limit = int(query_args["\$limit"])
    limit_counter = total_limit
    starting_offset = query_args["\$offset"]
    cont = true
    first_pass = true

    if total_limit > 1000 || total_limit == 0
        query_args["\$limit"] = 1000
    end

    # loop through and continually make get requests as long as:
    #    1) we haven't reached the user's set limit
    #    2) we haven't hit the end of the data from server

    while cont == true

        response = get(url, headers = header_args, query = query_args)

        # if the data request is empty, we know we're done...
        if contains(chomp(response.data), "\n") == false
            break
        end

        checkErrors(response)

        # Gets rid of additional headers that are generated from each request
        if first_pass == false
            write_data = write_data * response.data[(searchindex(response.data, "\n")+1):end]
        else
            write_data = write_data * response.data
        end

        # change a bunch of parameters to see whether loop continues
        if total_limit != 0
            limit_counter = limit_counter - 1000
            if limit_counter < 0
                cont = false
            end
        end
        first_pass = false
        query_args["\$offset"] = string(int(query_args["\$offset"]) + 1000)

    end

    return write_data

end