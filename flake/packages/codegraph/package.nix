{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "codegraph";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "colbymchenry";
    repo = "codegraph";
    rev = "f6772dac7cbcc8d45c15d7f54f1e6161962aa0ea";
    hash = "sha256-YhT/neYvLNbzJkOPmfRoDL5t149oAqF+slm7kaVsD54=";
  };

  npmDepsHash = "sha256-n8e/WuAlBDWsyweOOGUL23HrlomjQzsEzYSX7+51NeQ=";

  npmBuildScript = "build";

  meta = with lib; {
    description = "Pre-indexed code knowledge graph for Claude Code and friends";
    homepage = "https://github.com/colbymchenry/codegraph";
    license = licenses.mit;
    mainProgram = "codegraph";
  };
}
