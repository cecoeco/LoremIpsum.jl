module DocsLoremIpsum

using Documenter, LoremIpsum

Documenter.makedocs(;
    modules=[LoremIpsum],
    format=Documenter.HTML(),
    sitename="LoremIpsum.jl",
    authors="Ceco Elijah Maples and Contributors",
    pages=["API" => "api.md"],
)

Documenter.deploydocs(; repo="github.com/cecoeco/LoremIpsum.jl.git")

end # module