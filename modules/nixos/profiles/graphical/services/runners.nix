{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf genAttrs;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "graphical" ]) {
    environment.systemPackages = [ pkgs.appimage-run ];

    boot.binfmt.registrations =
      genAttrs
        [
          "appimage"
          "AppImage"
        ]
        (ext: {
          recognitionType = "extension";
          magicOrExtension = ext;
          interpreter = "/run/current-system/sw/bin/appimage-run";
        });

    programs.nix-ld = {
      enable = true;
      libraries = builtins.attrValues {
        inherit (pkgs)
          openssl
          curl
          glib
          util-linux
          glibc
          icu
          libunwind
          libuuid
          zlib
          libsecret
          freetype
          libglvnd
          libnotify
          SDL2
          vulkan-loader
          gdk-pixbuf
          ;

        inherit (pkgs.stdenv.cc) cc;
        inherit (pkgs.xorg) libX11;
      };
    };
  };
}
