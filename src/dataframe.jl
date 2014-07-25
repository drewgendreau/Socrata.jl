function dataframe(url::String, fulldataset::Bool, usefieldids::Bool, header_args::Dict, query_args::Dict)

    buffer = PipeBuffer()
    df = DataFrame()


    if fulldataset == true
        response = get(url)
        checkErrors(response)
        
        try
            write(buffer, response.data)
            df = readtable(buffer)
        finally
            close(buffer)
        end

    else
        # call getPagedData, which pages through multi-page requests

        write_data = getPagedData(url, header_args, query_args)
    
        try
            write(buffer, write_data)
            df = readtable(buffer)
        finally
            close(buffer)
        end

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
