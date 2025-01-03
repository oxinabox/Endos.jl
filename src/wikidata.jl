_WIKIDATA_CACHE = Dict{String, JSON3.Object}() 

"""
    search_wikidata(search_str::AbstractString)

Directly hits the wikidata API via search.
Resturns the data for the most relevent (best matching) result.

Example: `search_wikidata("haswbstatement:P683=16469")`
"""
function search_wikidata(search_str::AbstractString)
    get!(_WIKIDATA_CACHE, search_str) do
        search_url="https://www.wikidata.org/w/api.php?action=query"
        search_url *= "&list=search"
        search_url *= "&format=json"
        search_url *= "&srprop=extensiondata"
        search_url *= "&srsearch=$search_str"
        @debug "searching with" search_url
        search_resp = JSON3.read(HTTP.get(search_url).body)
        entity_id = first(search_resp.query.search).title

        data_url = "http://www.wikidata.org/entity/$entity_id.json"
        data_resp = JSON3.read(HTTP.get(data_url).body)
        return only(data_resp.entities)[2]
    end
end


function search_wikidata(s::SBML.Species)
    search_terms = String[]
    for cv_term in s.cv_terms
        cv_term.biological_qualifier == :is || continue
        for id_uri in cv_term.resource_uris
            search_term = to_search_term(id_uri)
            if !isnothing(search_term)
                push!(search_terms, search_term)
            end
        end
    end
    search_str = if isempty(search_terms)
        s.name
    else
        "haswbstatement:" * join(search_terms, "|")
    end
    return search_wikidata(search_str)
end

function to_search_term(url::AbstractString)
    for (prop, regex) in (
        "P2057" => r"https://identifiers.org/hmdb/(HMDB\d+)",
        "P683" => r"https://identifiers.org/chebi/CHEBI:(\d+)",
        "P662" => r"https://identifiers.org/pubchem.compound/(\d+)",
        "P2063" => r"https://identifiers.org/lipidmaps/(LMST\d+)",
    )
        m = match(regex, url)
        if !isnothing(m)
            return "$prop=$(only(m))"
        end
    end
end