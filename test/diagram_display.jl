using Endos
using SBML

model = human_gem()
species_by_name = index_species_by_name_and_compartment(model)

s_T = species_by_name["testosterone"]
s_DHT = species_by_name["5-alpha-dihydrotestosterone"]
s_E1 = species_by_name["estrone"]
s_E2 = species_by_name["estradiol-17beta"]
s_E3 = species_by_name["estriol"]
s_16α_OH_E1 = species_by_name["16alpha-hydroxyestrone"]


all_species_of_interest = values(s_T) ∪ values(s_DHT) ∪ values(s_E1) ∪ values(s_E2) ∪ values(s_E3) ∪ values(s_16α_OH_E1)
diagram(model, all_species_of_interest)


rs = reduce(union, reactions_involving.((model,), values(s_E1)))
print_chem.(Ref(model), last.(rs))