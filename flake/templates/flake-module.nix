{ ... }:
{
  flake.templates = {
    monorepo = {
      path = ./monorepo;
      description = "Data science/ML monorepo with UV workspace, Python 3.12, Marimo notebooks, and Nix flake-parts";
    };

    academic = {
      path = ./academic;
      description = "Academic research monorepo with UV workspace, LaTeX thesis, Python research packages, and Nix flake-parts";
    };
  };
}
