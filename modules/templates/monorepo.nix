# Template output: source tree lives in templates/monorepo (an independent
# flake, outside root module discovery).
{ ... }:
{
  flake.templates.monorepo = {
    path = ../../templates/monorepo;
    description = "Data science/ML monorepo with UV workspace, Python 3.12, Marimo notebooks, and Nix flake-parts";
  };
}
