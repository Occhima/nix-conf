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
    rev = "bc641077913c0ac043e702a8f6519189e89b1721";
    hash = "sha256-DGaF5iFqWy8nq8QwWWj/fK6xZCBXWE+9udBH6TNI288=";
  };

  npmDepsHash = "sha256-9x09s3PDEmM214QrlNgQoF9yKRqqNObedKL0ZTYNpcQ=";

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
