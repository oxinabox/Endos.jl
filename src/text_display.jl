
print_chem(io::IO, m::Model, s::Species) = print(io, s.name)
function print_chem(io::IO, m::Model, sr::SpeciesReference)
    if sr.stoichiometry != 1
        print(io, sr.stoichiometry)
        print(io, "*")
    end
    print_chem(io, m, m.species[sr.species])
end
function print_chem(io::IO, m::Model, (x, xxs...)::AbstractVector{SpeciesReference})
    print_chem(io, m, x)
    for x in xxs
        print(io, " + ")
        print_chem(io, m, x)
    end
end
function print_chem(io::IO, m::Model, r::Reaction)
    print_chem(io, m, r.reactants)
    print(io, r.reversible ? " --> " : " <=> ")
    print_chem(io, m, r.products)

    if !isnothing(r.name)
        print("\t(reaction: $(r.name))")
    end
    println(io)
end
print_chem(m::Model, x) = print_chem(stdout, m, x)
