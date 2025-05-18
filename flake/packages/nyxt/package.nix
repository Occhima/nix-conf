{
  lib,
  stdenvNoCC,
  fetchurl,

  # build
  appimageTools,
  openssl,
  libfixposix,

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
  version = "4.0.0-pre-release-7";
  sha256 = "sha256-gdA2Nit3Gcc5oPlheFsMHjCm0d1UX//zoLCAQnT5vUE=";

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

  buildInputs = [
    libfixposix
    egl-wayland
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    openssl
    libglvnd
    wayland
  ];

  runtimeDependencies = [
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

  postFixup = ''
    wrapProgram "$out/bin/nyxt" \
      --add-flags "--device=dri --socket=ffdssf --talk=asfd" \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --prefix PATH : "${
        lib.makeBinPath [
          xdg-utils
          # xclip
          # wl-clipboard
          # electron
          # wayland
          # libdrm
        ]
      }"
  '';

  dontStrip = true;
  meta = with lib; {
    description = "Infinitely extensible web-browser (with Lisp development files using Electron platform port)";
    mainProgram = "nyxt";
    homepage = "https://nyxt.atlas.engineer";
    license = licenses.bsd3;
    platforms = platforms.linyux;
  };
}
