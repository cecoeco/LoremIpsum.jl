FROM julia:latest
COPY . .
RUN julia --project -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"
ENTRYPOINT [ "julia", "--project", "using LoremIpsum; LoremIpsum.app()" ]