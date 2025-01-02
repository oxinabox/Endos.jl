

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


function mermaid_string(m::SBML.Model, gr::SBML.GPARef)
    gp = m.gene_products[gr.gene_product]
    str = gp.label

    uris = reduce(vcat, cv.resource_uris for cv in gp.cv_terms)
    filter!(contains("uniprot"), uris)
    if !isempty(uris)
        uri = first(uris)
        str *= """(<a href='$uri'>⛓</a>)"""
    end
    return str
end

function mermaid_string(m::SBML.Model, op::Union{SBML.GPAOr,SBML.GPAAnd})
    delim = op isa SBML.GPAAnd ? " & " : " | " 
    return join(mermaid_string.(Ref(m), op.terms), delim)
end

function mermaid_string(m::SBML.Model, ((m1name, m2name), rs))
    gprs = unique(r.gene_product_association for r in rs if !isnothing(r.gene_product_association))  # TODO May need to merge within Ors
    label = join((mermaid_string(m, gpr) for gpr in gprs), " | ")

    reversible = any(r.reversible for r in rs)
    conn = if !isempty(label) && reversible
        "<-$label->"
    elseif isempty(label) && reversible
        "<->"
    elseif !isempty(label) && !reversible
        "--$label->"
    else
        @assert isempty(label) && !reversible
        "-->"
    end
    
    return "\t$m1name $conn $m2name"
end

vertex_name(s::SBML.Species) = s.name

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

    edges = map(Base.Fix1(mermaid_string, model), collect(names2reactions))

    print("flowchart TD")
    lines = collect(values(name2vertex))
    push!(lines, "")
    append!(lines, edges)
    print(join(lines, "\n"))
end