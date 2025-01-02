using Endos
using SBML

model = human_gem()


species_by_name = index_species_by_name_and_compartment(model)

species_T = species_by_name["testosterone"]["c"]
reactions_from_T = filter(model.reactions) do (_, r)
    # TODO: do i need to handle reactions that run backwards? (check bounds)
    # or reactions with negative stoichiometry?
    return species_T.metaid ∈ (m.species for m in r.reactants)
end


for r in values(reactions_from_T)
    print_chem(model, r)
end