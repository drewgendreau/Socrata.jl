function socrata(url::String;
                    app_token::String="",
                    format::String="DataFrame",
                    select::String="",
                    where::String="",
                    order::String="",
                    group::String="",
                    q::String="",
                    limit::String="0",
                    offset::String="0",
                    fulldataset::Bool=false,
                    usefieldids::Bool=false)

    # create format
    if format == "DataFrame"
        format = "text/csv"
    elseif format == "json"
        # format = "application/json"
        error("Support for JSON not yet implemented.")
    elseif format == "rdf-xml"
        # format = "application/rdf+xml"
        error("Support for RDF-XML not yet implemented.")
    else
        error("Invalid format: $format.  Must be equal to csv, json, or rdf-xml.")
    end

    try
        float(limit)
    catch
        error("Limit needs to be an integer within a string (ex: \"100\")")
    end


    if float(limit) < 0
        error("Limit out of bounds.  Must be greater than or equal to 0.")
    end

    # Create a dictionary with the Header and Query args for the get function
    header_args = {"X-App-Token" => app_token, "Accept" => format}
    
    query_args = {"\$limit" => limit, "\$offset" => offset, "\$select" => lowercase(select), 
                     "\$where" => where, "\$order" => order, "\$group" => group, "\$q" => q}
    
    url = createURL(url, fulldataset)

    df = dataframe(url, fulldataset, usefieldids, header_args, query_args)
   
    return df
end