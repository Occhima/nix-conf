# Template output: source tree lives in ./_monorepo (an independent
# flake; the underscore prefix keeps it out of import-tree discovery).
{
  flake.templates.monorepo = {
    path = ./_monorepo;
    description = "Data science/ML monorepo with UV workspace, Python 3.12, Marimo notebooks, and Nix flake-parts";
  };
}
