{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
  zlib,
}:

let
  version = "0.0.1782579189-g03e27d";
  sources = {
    "x86_64-linux" = {
      url = "https://static.ampcode.com/cli/${version}/amp-linux-x64";
      hash = "sha256-SLq1DMuG3CkOiwXgThPlKa3FpeceifGHy3F0vyVaMIU=";
    };
    "aarch64-linux" = {
      url = "https://static.ampcode.com/cli/${version}/amp-linux-arm64";
      hash = "sha256-HXK+Iac7C8n10CywnfmAV2CNi0eK3R53LkV0ZwrFgog=";
    };
    "x86_64-darwin" = {
      url = "https://static.ampcode.com/cli/${version}/amp-darwin-x64";
      hash = "sha256-1MZSTfMKZjA7MVJMBgHm2iIAkTXDsACk6ir5pcI4dic=";
    };
    "aarch64-darwin" = {
      url = "https://static.ampcode.com/cli/${version}/amp-darwin-arm64";
      hash = "sha256-7lpiTi3mIDWdspGOOIvzuIZvW/xYNh7HMOWXjixC34k=";
    };
  };
in
stdenv.mkDerivation {
  pname = "ampcode";
  inherit version;

  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "ampcode: unsupported system ${stdenv.hostPlatform.system}")
  );

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
    zlib
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/amp
    chmod +x $out/bin/amp
  '';

  meta = with lib; {
    description = "Amp CLI - AI coding agent";
    homepage = "https://ampcode.com";
    license = licenses.unfree;
    mainProgram = "amp";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
