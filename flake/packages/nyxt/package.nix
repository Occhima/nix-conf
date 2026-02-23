{
  lib,
  stdenvNoCC,
  fetchurl,

  # build
  appimageTools,
  cacert,
  openssl,
  enchant,
  electron,
  xdg-utils,
  autoPatchelfHook,
  libglvnd,
  glibcLocales,
  makeWrapper,
  wayland,
  egl-wayland,
  runCommand,

  # Creating desktop entries
  makeDesktopItem,
  copyDesktopItems,

  ...

}:
let
  pname = "nyxt";
  version = "4.0.0";
  sha256 = "sha256-v+x6K5svLA3L+IjEdTjmJEf3hvgwhwrvqAcelpY1ScQ=";
  binaryName = "nyxt";

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
    copyDesktopItems
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    openssl
    libglvnd
    wayland
    egl-wayland
    electron
    enchant

  ];

  # sourceRoot = lib.optionalString hostPlatform.isDarwin ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r bin/${binaryName} $out/bin/nyxt

    install -D ${appimageContents}/nyxt.png  $out/share/icons/hicolor/16x16/apps/nyxt.png
    install -D ${appimageContents}/nyxt.png  $out/share/icons/hicolor/32x32/apps/nyxt.png
    install -D ${appimageContents}/nyxt.png  $out/share/icons/hicolor/48x48/apps/nyxt.png
    install -D ${appimageContents}/nyxt.png  $out/share/icons/hicolor/64x64/apps/nyxt.png
    install -D ${appimageContents}/nyxt.png  $out/share/icons/hicolor/128x128/apps/nyxt.png

    runHook postInstall
  '';

  # --set to set env variables
  postFixup = ''
    wrapProgram "$out/bin/nyxt" \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --set-default SSL_CERT_FILE  ${cacert}/etc/ssl/certs/ca-bundle.crt \
      --set-default CURL_CA_BUNDLE ${cacert}/etc/ssl/certs/ca-bundle.crt \
      --prefix PATH : "${
        lib.makeBinPath [
          xdg-utils
          openssl
          enchant
          electron
          libglvnd
          wayland
        ]
      }"
  '';
  desktopItems = [
    (makeDesktopItem {
      name = "nyxt";
      desktopName = "Nyxt";
      comment = "A browser for Hackers";
      exec = "${binaryName} %u"; # relies on profile PATH; simple & clean
      icon = "${binaryName}"; # resolved by the hicolor icon we installed
      type = "Application";
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "application/x-xpinstall"
        "application/pdf"
        "application/json"
      ];
      startupWMClass = binaryName;
      categories = [
        "Network"
        "WebBrowser"
      ];
      startupNotify = true;
      terminal = false;
      keywords = [
        "Internet"
        "WWW"
        "Browser"
        "Web"
        "Explorer"
      ];

      actions = {
        new-windows = {
          name = "Open a New Window";
          exec = "${binaryName} %u";
        };
      };
    })
  ];

  dontStrip = true;
  meta = {
    description = "Infinitely extensible web-browser (with Lisp development files using Electron platform port)";
    mainProgram = "nyxt";
    homepage = "https://nyxt.atlas.engineer";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
