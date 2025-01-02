module Endos
using DataDeps
using SBML
using SBML: Reaction, Species, SpeciesReference, Model
using HTTP, JSON3

export human_gem, print_chem, index_species_by_name_and_compartment, search_wikidata

include("data.jl")
include("text_display.jl")
include("wikidata.jl")
include("sbml_helpers.jl")

function __init__()
    init_data()
end

end
