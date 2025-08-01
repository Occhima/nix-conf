{
  lib,
  stdenvNoCC,
  fetchurl,

  # build
  appimageTools,
  openssl,
  electron,
  xdg-utils,
  autoPatchelfHook,
  libglvnd,
  glibcLocales,
  makeWrapper,
  wayland,
  egl-wayland,
  runCommand,
  ...

}:
let
  pname = "nyxt";
  version = "4.0.0-pre-release-12";
  sha256 = "sha256-ELwMgGZ5tYXTM5cY8n0/vs1dJbB9EHUqV/KVXEEEIps=";

  source = fetchurl {
    inherit sha256;
    url = "https://github.com/atlas-engineer/nyxt/releases/download/${version}/Linux-Nyxt-x86_64.tar.gz";

  };

  unpackedSource = runCommand "${pname}-${version}.AppImage" { } ''
    tar -xO \
    --wildcards '*.AppImage' \
    -f ${source} > $out
    chmod +x $out
  '';

  # Linux -- build from AppImage
  appimageContents = appimageTools.extractType2 {
    inherit version pname;
    src = unpackedSource;
  };

  wrappedAppimage = appimageTools.wrapType2 {
    inherit version pname;
    src = unpackedSource;
  };

in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = wrappedAppimage;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    glibcLocales
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    openssl
    libglvnd
    wayland
    egl-wayland
    electron
  ];

  # sourceRoot = lib.optionalString hostPlatform.isDarwin ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r bin $out/bin
    cp -r ${appimageContents}/nyxt.desktop $out
    runHook postInstall
  '';

  # --set to set env variables
  postFixup = ''
    wrapProgram "$out/bin/nyxt" \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --prefix PATH : "${
        lib.makeBinPath [
          xdg-utils
          openssl
          electron
          libglvnd
          wayland
        ]
      }"
  '';

  dontStrip = true;
  meta = {
    description = "Infinitely extensible web-browser (with Lisp development files using Electron platform port)";
    mainProgram = "nyxt";
    homepage = "https://nyxt.atlas.engineer";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
