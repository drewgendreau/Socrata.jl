function dataframe(url::String)

    response = get(url)

    buffer = PipeBuffer()
    df = DataFrame()

    try
        write(buffer, response.data)
        df = readtable(buffer)

    finally
        close(buffer)
    end

    return df

end


function partialdataframe(url::String, query_args)

    buffer = PipeBuffer()
    df = DataFrame()

    try
        response = get(url)
        write(buffer, response.data)

        data = chomp(response.data)
        data = split(response.data, "\n")

        while length(data) == 1000
            offset = offset + 1000
            url = changeLimitOffset(url, limit, offset)

            response = get(url)
            data = chomp(response.data)
            data = split(response.data, "\n")
            
            for i = 2:length(data)  # Skip header row on subsequent data pulls          
                write(buffer, data[i], "\n")
            end
        end

        df = readtable(buffer)

    finally
        close(buffer)
    end

    return df
end

# cases: 

# nrows = 300
# nrows = 1000
# nrows = 1300
# nrows = 1300 and offset = 500
# nrows = 4000 and offset = 500




function partialdataframe2(url::String, query_args)

    
    offset = integer(get(query_args, "offset", 0))
    limit = integer(get(query_args, "limit", 100))

    full_pages = floor(limit / 1000)
    last_limit = mod(limit, 1000)

    buffer = PipeBuffer()
    df = DataFrame()

    try

            url = changeLimitOffset(url, 1000, offset)

            for i = 1:full_pages
                response = get(url)
                write(buffer, response.data)

                # change offset
                url = changeLimitOff

            end

            # final get and write


            # then read the data into a data frame
            df = readtable(buffer)

    finally
        close(buffer)
    end

    return df
end