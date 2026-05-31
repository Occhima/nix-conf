{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "codegraph";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "colbymchenry";
    repo = "codegraph";
    rev = "b026e64b413bb4dca1bc7326d7de0837afe0a899";
    hash = "sha256-+pfuglPHbLkl3v3DuYvdVsxjJeQxoQkZmlZbvMNvkmY=";
  };

  npmDepsHash = "sha256-svl9IrD3iisl66wYPzy3WzR5oa4yJ0dRSrVrJv4/A94=";

  npmBuildScript = "build";

  meta = with lib; {
    description = "Pre-indexed code knowledge graph for Claude Code and friends";
    homepage = "https://github.com/colbymchenry/codegraph";
    license = licenses.mit;
    mainProgram = "codegraph";
  };
}
