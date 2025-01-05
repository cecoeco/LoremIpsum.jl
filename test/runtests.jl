#module TestLoremIpsum

using Test, HTTP, NodeJS, Random #=, LoremIpsum=#

function vitestjs()::Bool
    Base.run(`$(NodeJS.npm_cmd()) install`)

    output::String = Base.read(`$(NodeJS.npm_cmd()) test`, String)

    if Base.occursin(r"Test Files\s+\d+\spassed", output)
        return true
    end

    Base.CoreLogging.@warn "Vitest tests did not pass:\n$output"

    return false
end

@testset "vitest.js" begin
    @test vitestjs()
end

const HOST::String = "127.0.0.1"
const PORT::Int = 5050
const URL::String = "http://$HOST:$PORT/"

function startapp()::Bool
    Base.@async begin
        try
            LoremIpsum.app(HOST, PORT)
        catch e
            Base.CoreLogging.@warn "Failed to start application: $e"
        end
    end

    for idx in 1:10
        try
            response = HTTP.get(URL)
            if response.status == 200
                return true
            end
        catch
            Base.CoreLogging.@info "Attempt $idx to connect to server failed, retrying..."
            Base.sleep(5)
        end
    end

    return false
end

function stopapp()::Bool
    try
        HTTP.close(LoremIpsum.app(HOST, PORT))

        return true
    catch e
        Base.CoreLogging.@warn "Failed to stop application: $e"

        return false
    end
end

@testset "react.js" begin
    @test startapp() || return nothing

    try
        @testset "index.html" begin
            response::HTTP.Response = HTTP.get(URL)
            headers::Vector{Pair{String,String}} = response.headers
            body::String = String(response.body)

            @test response.status == 200
            @test headers[1] == Pair("Content-Type", "text/html; charset=utf-8")
            @test occursin("<title>LoremIpsum.jl</title>", body)
            @test occursin("index.js", body)
            @test occursin("index.css", body)
        end
    finally
        @test stopapp() || return nothing
    end
end

@testset "api" begin
    @test startapp() || return nothing
    try
        #TODO: add more test for the REST API
    finally
        @test stopapp() || return nothing
    end
end

#end # module
