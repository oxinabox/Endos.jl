using Endos
using Test
using SafeTestsets

@testset "Endos.jl" begin
    @safetestset "basic_query.jl" include("basic_query.jl")
    @safetestset "wikidata.jl" include("wikidata.jl")
end
