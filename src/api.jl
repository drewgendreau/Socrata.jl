function socrataget(url::String;
                    limit::String="100",
                    offset::String="0",
                    app_token::String="")

    if limit == "all"  # indicates users wants all rows 
        url = fullURL(url)
        df = fulldataframe(url)
    else
        # Create a dictionary with the Query args for the get function
        query_args = {"limit" => limit, "offset" => offset, "app_token" => app_token}
        
        url = partialURL(url, query_args)
        df = partialdataframe(url, query_args)
    end

    return df
end

# make socrata an alias for socrataget
socrata(args...) = socrataget(args...)