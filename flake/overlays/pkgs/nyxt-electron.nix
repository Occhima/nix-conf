# NOTE: stolen from https://github.com/shaunsingh/nix-darwin-dotfiles/blob/main/nyxt4-wrapped/default.nix
_self: prev:

let
  # helper to shorten attribute names
  pkgs = prev;
  lib = prev.lib;
in
{
  nyxt-electron = pkgs.nyxt.overrideAttrs (_oldAttrs: rec {
    pname = "nyxt4-3";
    version = "4.0.0-pre-release-3";

    # upstream publishes full source tarballs with submodules
    src = pkgs.fetchzip {
      url = "https://github.com/atlas-engineer/nyxt/releases/download/${version}/nyxt-${version}-source-with-submodules.tar.xz";
      hash = "sha256-T5p3OaWp28rny81ggdE9iXffmuh6wt6XSuteTOT8FLI=";
      stripRoot = false; # keep top‑level dir – Nyxt’s build expects it
    };

    # extra libraries Nyxt loads via CFFI at runtime
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.glib
      pkgs.gobject-introspection
      pkgs.gdk-pixbuf
      pkgs.cairo
      pkgs.pango
      pkgs.gtk3
      pkgs.openssl
      pkgs.libfixposix
      pkgs.sqlite # <-- add sqlite (missing in your snippet)
      pkgs.webkitgtk # Electron/WebKit variant Nyxt needs
      pkgs.electron
    ];
    # makeFlags = [
    #   "all"
    #   # build cl-electron in nix instead of npm.
    #   # "NODE_SETUP=false"
    #   # "NYXT_SUBMODULES=true"
    #   "NYXT_RENDERER=electron"
    # ];
    # cosmetic: identify the main binary for `nix run`
    meta.mainProgram = "nyxt";
  });
}
