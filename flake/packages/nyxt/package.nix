{
  pkgs,
  ...
}:

let
  pname = "nyxt";
  version = "4.0.0-pre-release-6";
  nyxtSHA = "sha256-gdA2Nit3Gcc5oPlheFsMHjCm0d1UX//zoLCAQnT5vUE=";

  nyxtAppImageGz = pkgs.fetchurl {
    url = "https://github.com/atlas-engineer/nyxt/releases/download/${version}/Linux-Nyxt-x86_64.tar.gz";
    sha256 = nyxtSHA;
  };

  nyxtAppImage = pkgs.runCommand "${pname}-${version}.AppImage" { } ''
    ${pkgs.gnutar}/bin/tar -xO \
    --wildcards '*.AppImage' \
    -f ${nyxtAppImageGz} > $out
    chmod +x $out
  '';
in
pkgs.appimageTools.wrapType2 {
  inherit pname version;
  src = nyxtAppImage;
  extraPkgs =
    pkgs: with pkgs; [
      electron
      fuse
      libnotify
      egl-wayland
    ];
}
