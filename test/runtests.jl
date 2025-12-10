using Test
using SafeTestsets

@testset "Endos.jl" begin
    @safetestset "text_display.jl" include("text_display.jl")
    @safetestset "wikidata.jl" include("wikidata.jl")
    @safetestset "diagram_display.jl" include("diagram_display.jl")
end
