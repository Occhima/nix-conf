{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "agentmemory";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "rohitg00";
    repo = "agentmemory";
    rev = "355124141625ccc0d740ae08ddaaf77fe2c165ae";
    hash = "sha256-ziK/yA1LK6XO5iNTfykNL5vJPDIdsUfhAYv9N6dcJLI=";
  };

  npmDepsHash = "sha256-BLZOS/FnbBOtN50NWQb8aEu9Kuax87Dc6afbTdEXFqA=";

  npmBuildScript = "build";
  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  meta = with lib; {
    description = "Persistent memory for AI coding agents";
    homepage = "https://github.com/rohitg00/agentmemory";
    license = licenses.asl20;
    mainProgram = "agentmemory";
  };
}
