

function best_title(wikidata)
    #candidates = [x.value for x in wikidata.aliases.en]
    #push!(candidates, wikidata.labels.en.value)
    #return partialsort!(candidates, 1; by=length, rev=false)
    return wikidata.sitelinks.enwiki.title
end

function mermaid_string(s::SBML.Species)
    title = s.name
    url_str = ""
    try
        wikidata = search_wikidata(s)
        wikipedia_url = wikidata.sitelinks.enwiki.url
        title = best_title(wikidata)
        url_str = """\t(<a href='$wikipedia_url'>⛓</a>)"""
    catch e
        if !(e isa BoundsError)
            rethrow(e)
        end
    end
    
    return "\t$(vertex_name(s))(\"$title $url_str\")"
end

vertex_name(s::SBML.Species) = s.name

merge_reaction(r1, ::Nothing) = r1

function diagram(model, species_of_interest)
    # We assume name is a consistent representation of the metabolite that is compartment independent
    name2vertex = Dict{String, String}()

    species_id2name = Dict{String, String}()
    for s in species_of_interest
        species_id2name[s.metaid] = vertex_name(s)
        get!(name2vertex, vertex_name(s)) do
            # only create for first time we see this name
            mermaid_string(s)
        end
    end

    names2reactions = Dict{Tuple{String,String}, Vector{SBML.Reaction}}()
    for (_, r) in model.reactions
        for m1 in r.reactants
            m1name = get(species_id2name, m1.species, nothing)
            isnothing(m1name) && continue
            for m2 in r.products
                m2name = get(species_id2name, m2.species, nothing)
                isnothing(m2name) && continue
                m1name == m2name && continue  # No-self loops
                reactions = get!(Vector{SBML.Reaction}, names2reactions, (m1name, m2name))
                push!(reactions, r)
            end
        end
    end

    edges = map(collect(names2reactions)) do ((m1name, m2name), rs)
        conn = any(r.reversible for r in rs) ? "<-->" : "-->"
        return "\t$m1name $conn $m2name"
    end

    print("flowchart TD")
    lines = collect(values(name2vertex))
    push!(lines, "")
    append!(lines, edges)
    print(join(lines, "\n"))
end