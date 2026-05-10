{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "jcode";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "jcode";
    rev = "v${version}";
    hash = "sha256-j8rgKsZ+ISbogCUSU63s9E/rqvLbvpIQnN8h2xSXRUc=";
  };

  cargoHash = "sha256-OAF5GKNSCzV8ZvhXP1w6179vrEhaFWd2MlpdGvWve6g=";

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
