function index_species_by_name_and_compartment(model)
    species_by_name = Dict{String, Dict{String, SBML.Species}}()
    for (_, s) in model.species
        get!(Dict{String, SBML.Species}, species_by_name, s.name)[s.compartment] = s
    end
    return species_by_name
end