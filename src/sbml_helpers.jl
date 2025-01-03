function index_species_by_name_and_compartment(model)
    species_by_name = Dict{String, Dict{String, SBML.Species}}()
    for (_, s) in model.species
        get!(Dict{String, SBML.Species}, species_by_name, s.name)[s.compartment] = s
    end
    return species_by_name
end


function reactions_from(model, target)
    filter(model.reactions) do (_, r)
    # TODO: do i need to handle reactions that run backwards? (check bounds)
    # or reactions with negative stoichiometry?
        return target.metaid ∈ (m.species for m in r.reactants)
    end
end

function reactions_to(model, target)
    filter(model.reactions) do (_, r)
    # TODO: do i need to handle reactions that run backwards? (check bounds)
    # or reactions with negative stoichiometry?
        return target.metaid ∈ (m.species for m in r.products)
    end
end

function reactions_involving(model, target)
    filter(model.reactions) do (_, r)
        return ( 
            target.metaid ∈ (m.species for m in r.products) || 
            target.metaid ∈ (m.species for m in r.reactants)
        )
    end
end