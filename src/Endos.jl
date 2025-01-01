module Endos
using DataDeps
using SBML
using SBML: Reaction, Species, SpeciesReference, Model

export human_gem, print_chem

include("data.jl")
include("text_display.jl")

function __init__()
    init_data()
end

end
