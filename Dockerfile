FROM julia:latest
COPY . .
RUN julia --project -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"
ENTRYPOINT [ "julia", "--project", "-e", "using LoremIpsum; LoremIpsum.app()" ]