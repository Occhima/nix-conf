{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "jcode";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "jcode";
    rev = "v${version}";
    hash = "sha256-q4FjQv7K2omkTlGtg5vmO8S2j4chZfxOULJ4z9VtruQ=";
  };

  cargoHash = "sha256-hThav0a8Ua8fm4c56topkG7pZhRfkONvxkzTp/eXylc=";

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
