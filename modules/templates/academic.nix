# Template output: source tree lives in templates/academic (an independent
# flake, outside root module discovery).
{ ... }:
{
  flake.templates.academic = {
    path = ../../templates/academic;
    description = "Academic research monorepo with UV workspace, LaTeX thesis, Python research packages, and Nix flake-parts";
  };
}
