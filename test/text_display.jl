using Test
using Endos
using SBML

model = human_gem()
species_by_name = index_species_by_name_and_compartment(model)

species_T = species_by_name["testosterone"]["c"]
reactions_from_T = reactions_from(model, species_T)
@testset "$(r.metaid)" for r in values(reactions_from_T)
    @test contains(str_chem(model, r), "<->") || contains(str_chem(model, r), "-->")
end


r = model.reactions["MAR02036"]

@test ==(
    str_chem(model, r.gene_product_association),
    "HSD17B6 | HSD17B2 | HSD17B1 | HSD17B7 | HSD17B12 | HSD17B11 | HSD17B8"
)