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
    rev = "c14bdc50d4aaa98302b40c39064ef5a542f188df";
    hash = "sha256-BB0Jb3EdSQJDW2arBQ5qjgBKPD29+LH8YGOcODlHSho=";
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
