{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "jcode";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "jcode";
    rev = "v${version}";
    hash = "sha256-ZuBVChtHxAFnLax/bgI/5OilPRKO5MJ3UTKNT/3CCIg=";
  };

  cargoHash = "sha256-ycSpYBiOd13fsnuYU1y9Wmkj3YF9XhlWyRogf+AnlZQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoBuildFlags = [
    "--bin"
    "jcode"
  ];

  cargoTestFlags = [
    "--bin"
    "jcode"
  ];

  meta = with lib; {
    description = "Fast TUI coding agent with multi-model and tool support";
    homepage = "https://github.com/1jehuang/jcode";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "jcode";
  };
}
