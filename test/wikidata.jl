using Endos

@testset "to_search_term" begin
    to_search_term = Endos.to_search_term
    @test to_search_term("https://identifiers.org/bigg.metabolite/tststerone") == nothing
    @test to_search_term("https://identifiers.org/kegg.compound/C00535") == nothing
    @test to_search_term("https://identifiers.org/hmdb/HMDB0000234") == "P2057=HMDB0000234"
    @test to_search_term("https://identifiers.org/chebi/CHEBI:17347") == "P683=17347"
    @test to_search_term("https://identifiers.org/pubchem.compound/6013") == "P662=6013"
    @test to_search_term("https://identifiers.org/lipidmaps/LMST02020002") == "P2063=LMST02020002"
end

@testset "search_wikidata" begin
    model = human_gem()
    species_by_name = index_species_by_name_and_compartment(model)

    estradoil_species = species_by_name["estradiol-17beta"]["c"]
    @test search_wikidata(estradoil_species).id == "Q422416"

    estrone_species = species_by_name["estrone"]["c"]
    @test search_wikidata(estrone_species).id == "Q414986"

    estriol_species = species_by_name["estriol"]["c"]
    @test search_wikidata(estriol_species).id == "Q409721"
end