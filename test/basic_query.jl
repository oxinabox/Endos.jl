using Endos
using SBML

model = human_gem()

species_by_name = Dict{String, Dict{String, SBML.Species}}()
species_by_chebi = Dict{String, Dict{String, SBML.Species}}()
for (_, s) in model.species
    get!(Dict{String, SBML.Species}, species_by_name, s.name)[s.compartment] = s
end

species_T = species_by_name["testosterone"]["c"]
reactions_from_T = filter(model.reactions) do (_, r)
    # TODO: do i need to handle reactions that run backwards? (check bounds)
    # or reactions with negative stoichiometry?
    return species_T.metaid ∈ (m.species for m in r.reactants)
end


for r in values(reactions_from_T)
    print_chem(model, r)
end