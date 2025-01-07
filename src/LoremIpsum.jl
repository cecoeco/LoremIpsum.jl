module LoremIpsum

using HTTP

export app, lorem_ipsum, LOREM_IPSUM

const LOREM_IPSUM::String = """
Lorem ipsum dolor sit amet, 
consectetur adipiscing elit, 
sed do eiusmod tempor incididunt 
ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud 
exercitation ullamco laboris nisi 
ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit 
in voluptate velit esse cillum dolore 
eu fugiat nulla pariatur. Excepteur 
sint occaecat cupidatat non proident, 
sunt in culpa qui officia deserunt 
mollit anim id est laborum
"""

"""
    lorem_ipsum(; random::Bool=false, length::Int=100)::String

Generate a random or deterministic string of Lorem Ipsum.

## Keyword Arguments
- `random::Bool`: Generate a random string.
- `length::Int`: The length of the string.

## Returns
- `String`: A string of Lorem Ipsum.

"""
function lorem_ipsum(; random::Bool=false, length::Int=100)::String
    if random
        return Base.join([Base.rand(LOREM_IPSUM) for _ in 1:length])
    else
        return LOREM_IPSUM[1:Base.min(length, end)]
    end
end

"""
    lorem_ipsum(req::HTTP.Request)::HTTP.Response

Generate a random or deterministic string of Lorem Ipsum as an HTTP response.

## Arguments
- `req::HTTP.Request`: The HTTP request.

## Returns
- `HTTP.Response`: An HTTP response containing a string of Lorem Ipsum.

"""
function lorem_ipsum(req::HTTP.Request)::HTTP.Response
    return HTTP.Response(
        200,
        ["Content-Type" => "text/plain"];
        body=lorem_ipsum(;
            random=HTTP.getparam(req, "random", "false") == "true",
            length=Base.parse(Int, HTTP.getparam(req, "length", "100")),
        ),
    )
end

const DIST::String = Base.joinpath(Base.@__DIR__, "dist")
const ROUTER::HTTP.Router = HTTP.Router()

"""
    app(host::String="0.0.0.0", port::Int=5050; kwargs...)

Start the web application at the specified host and port.

## Arguments
- `host::String`: The host to listen on (default: "0.0.0.0").
- `port::Int`: The port to listen on (default: 5050).
- `kwargs...`: Additional keyword arguments to pass to `HTTP.serve`.

"""
function app(host::String="0.0.0.0", port::Int=5050; kwargs...)
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

    return HTTP.serve(ROUTER, host, port; kwargs...)
end

end # module