module LoremIpsum

using HTTP

export app, lorem_ipsum, LOREM_IPSUM

const LOREM_IPSUM::String = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
"""

function lorem_ipsum(; random::Bool=false, length::Int=100)::String
    if random
        return join([rand(LOREM_IPSUM) for _ in 1:length])
    else
        return LOREM_IPSUM[1:min(length, end)]
    end
end

function lorem_ipsum(req::HTTP.Request)::HTTP.Response
    random::Bool = HTTP.getparam(req, "random", "false") == "true"
    length::Int = Base.parse(Int, HTTP.getparam(req, "length", "100"))

    return HTTP.Response(200, lorem_ipsum(; random=random, length=length))
end

const DIST::String = Base.joinpath(Base.@__DIR__, "dist")
const ROUTER::HTTP.Router = HTTP.Router()

function app(host::String="0.0.0.0", port::Int=5050; kwargs...)::HTTP.Server
    HTTP.register!(
        ROUTER,
        "GET",
        "/",
        request -> HTTP.Response(
            200,
            ["Content-Type" => "text/html"];
            body=Base.read(Base.joinpath(DIST, "index.html")),
        ),
    )
    HTTP.register!(
        ROUTER,
        "GET",
        "/index.js",
        request -> HTTP.Response(
            200,
            ["Content-Type" => "application/javascript"];
            body=Base.read(Base.joinpath(DIST, "index.js")),
        ),
    )
    HTTP.register!(
        ROUTER,
        "GET",
        "/index.css",
        request -> HTTP.Response(
            200,
            ["Content-Type" => "text/css"];
            body=Base.read(Base.joinpath(DIST, "index.css")),
        ),
    )
    HTTP.register!(
        ROUTER,
        "GET",
        "/book.svg",
        request -> HTTP.Response(
            200,
            ["Content-Type" => "image/svg+xml"];
            body=Base.read(Base.joinpath(DIST, "book.svg")),
        ),
    )

    HTTP.register!(ROUTER, "GET", "/api/{random}/{length}", lorem_ipsum)

    return HTTP.serve!(ROUTER, host, port; kwargs...)
end

app()

end # module