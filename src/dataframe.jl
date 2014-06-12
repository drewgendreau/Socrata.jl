function dataframe(url::String, fulldataset::Bool, usefieldids::Bool, header_args::Dict, query_args::Dict)

    if fulldataset == true
        println("Getting full data set, ignoring all query parameters\n")
        response = get(url)
    else
        response = get(url, headers = header_args, query = query_args)
    end

    #println(response.status)
    #println(response.headers)
    #println(response.data)

    checkErrors(response)

    buffer = PipeBuffer()
    df = DataFrame()

    try
        write(buffer, response.data)
        df = readtable(buffer)
    finally
        close(buffer)
    end

    # TODO:
    # Socrata exports missing values using the string term "NULL"
    # Need to convert "NULL" values to NA

    if usefieldids == true

        # new_colnames = getFieldIDs(url, fulldataset, header_args)
        
        # println("DF Names: ", names(df), "\n")
        # println("NewCols: ", new_colnames, "\n")

        # names!(df, new_colnames)

        println("usefieldids has not yet been implemented.")

    end

    return df

end
