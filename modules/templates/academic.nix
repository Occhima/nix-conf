# Template output: source tree lives in ./_academic (an independent
# flake; the underscore prefix keeps it out of import-tree discovery).
{ ... }:
{
  flake.templates.academic = {
    path = ./_academic;
    description = "Academic research monorepo with UV workspace, LaTeX thesis, Python research packages, and Nix flake-parts";
  };
}
