using Endos
using SBML

model = human_gem()
species_by_name = index_species_by_name_and_compartment(model)

species_T = species_by_name["testosterone"]["c"]
reactions_from_T = reactions_from(model, species_T)
for r in values(reactions_from_T)
    print_chem(model, r)
end