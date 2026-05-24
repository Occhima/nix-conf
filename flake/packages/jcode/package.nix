{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "jcode";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "jcode";
    rev = "v${version}";
    hash = "sha256-4spsWpmfQ2H7hURRwghMzlx6+2pt2tyoAwyu51D2MGg=";
  };

  cargoHash = "sha256-T5WykR3Og8lRHRm9MvwMC9+GQsD4EbSyxgxrJPN8BT8=";

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
