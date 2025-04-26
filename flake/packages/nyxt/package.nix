{
  pkgs,
  ...
}:

let
  pname = "nyxt";
  version = "4.0.0-pre-release-6";
  nyxtSHA = "sha256-mZ+2OtZy26hErl0LQcA57EtYdcRv5yjJVDXFwXREzf0=";

  nyxtAppImageGz = pkgs.fetchurl {
    url = "https://github.com/atlas-engineer/nyxt/releases/download/${version}/Linux-Nyxt-x86_64.AppImage.gz";
    sha256 = nyxtSHA;
  };

  nyxtAppImage = pkgs.runCommand "${pname}-${version}.AppImage" { } ''
    ${pkgs.gzip}/bin/gunzip -c ${nyxtAppImageGz} > $out
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
    ];
}
