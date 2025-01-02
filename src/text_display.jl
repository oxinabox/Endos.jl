print_chem(io::IO, m::SBML.Model, s::SBML.Species) = print(io, "$(s.name) [$(s.compartment)]")
function print_chem(io::IO, m::SBML.Model, sr::SBML.SpeciesReference)
    if sr.stoichiometry != 1
        print(io, sr.stoichiometry)
        print(io, "*")
    end
    print_chem(io, m, m.species[sr.species])
end
function print_chem(io::IO, m::SBML.Model, xs::AbstractVector{SBML.SpeciesReference})
    if isempty(xs)
        print(io, "nothing")
        return
    end
    (x, xxs...) = xs
    print_chem(io, m, x)
    for x in xxs
        print(io, " + ")
        print_chem(io, m, x)
    end
end
function print_chem(io::IO, m::SBML.Model, r::SBML.Reaction)
    print_chem(io, m, r.reactants)
    print(io, r.reversible ? " <-> " : " --> ")
    print_chem(io, m, r.products)

    if !isnothing(r.name)
        print(io, "\t(reaction: $(r.name))")
    end
    println(io)
end
print_chem(m::SBML.Model, x) = print_chem(stdout, m, x)

function str_chem(m::SBML.Model, x)
    iob = IOBuffer()
    print_chem(iob, m, x)
    seekstart(iob)
    return read(iob, String)
end