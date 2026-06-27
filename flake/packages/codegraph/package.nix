{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "codegraph";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "colbymchenry";
    repo = "codegraph";
    rev = "7a361ef16eee63ec61585c76aff6e2f7742211c0";
    hash = "sha256-08vEZe0N0lsAcHe0686GUhrqNVrMuKUVrIovp/baSoA=";
  };

  npmDepsHash = "sha256-SQmYRcDW/JDVVJ7fWW/FbVwxf1zBY9RVVsbIBnvrEU0=";

  npmBuildScript = "build";

  meta = with lib; {
    description = "Pre-indexed code knowledge graph for Claude Code and friends";
    homepage = "https://github.com/colbymchenry/codegraph";
    license = licenses.mit;
    mainProgram = "codegraph";
  };
}
