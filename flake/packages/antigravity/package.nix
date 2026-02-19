#NOTE: This code was stolen from: https://github.com/fdiblen/antigravity-nix/blob/main/package.nix, jsut added the desktop entries
{
  lib,
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "antigravity";
  version = "1.11.3-6583016683339776";

  src = pkgs.fetchurl {
    url = "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/${version}/linux-x64/Antigravity.tar.gz";
    sha256 = "025da512f9799a7154e2cc75bc0908201382c1acf2e8378f9da235cb84a5615b";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libGL
    libxkbcommon
    mesa
    nspr
    nss
    pango
    vulkan-loader
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libxkbfile
  ];

  runtimeDependencies = [
    pkgs.systemd
  ];

  sourceRoot = ".";

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "antigravity";
      desktopName = "Antigravity";
      comment = "AI Coding Agent IDE";
      exec = "antigravity %U";
      icon = "antigravity";
      startupWMClass = "Antigravity";
      type = "Application";
      categories = [
        "Development"
        "IDE"
      ];
      mimeTypes = [ "x-scheme-handler/antigravity" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/antigravity $out/share/applications $out/share/icons/hicolor/512x512/apps
    cp -r Antigravity/* $out/share/antigravity/ 2>/dev/null || cp -r * $out/share/antigravity/
    ln -s $out/share/antigravity/antigravity $out/bin/antigravity
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
      --prefix PATH : "${lib.makeBinPath [ pkgs.xdg-utils ]}"
    )
  '';

  meta = with lib; {
    description = "Google Antigravity - Agentic development platform powered by Gemini";
    homepage = "https://antigravity.google";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "antigravity";
  };
}
