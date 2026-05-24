{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "codegraph";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "colbymchenry";
    repo = "codegraph";
    rev = "1be8e7830f7ca37e42a378186b0274e684b1d4d8";
    hash = "sha256-g8wJmFB9k1tkjUxKjld4zRXp0A7oI+oRCaRFXg9HTOw=";
  };

  npmDepsHash = "sha256-GJfqzykgrgD/KCtf8LupRw31S2cCmwGCF/0PMpzaCrk=";

  npmBuildScript = "build";

  meta = with lib; {
    description = "Pre-indexed code knowledge graph for Claude Code and friends";
    homepage = "https://github.com/colbymchenry/codegraph";
    license = licenses.mit;
    mainProgram = "codegraph";
  };
}
