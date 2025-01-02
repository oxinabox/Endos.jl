module Endos
using DataDeps
using SBML
using HTTP, JSON3

export human_gem, print_chem, str_chem, search_wikidata, diagram
export index_species_by_name_and_compartment, reactions_from, reactions_to, reactions_involving

include("data.jl")
include("text_display.jl")
include("diagram_display.jl")
include("wikidata.jl")
include("sbml_helpers.jl")

function __init__()
    init_data()
end

end
