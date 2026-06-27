{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "jcode";
  version = "0.31.2";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "jcode";
    rev = "v${version}";
    hash = "sha256-Yt/SkBSdKQyd7hLkneAyF8yTjVMhEWP9JJEyXBmosVg=";
  };

  cargoHash = "sha256-d5y5oef2+VfjYGZnmPB/NZDpUQBkFLiSidA24D7OL9w=";

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
