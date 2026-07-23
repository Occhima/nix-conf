# emacs-doom: Doom Emacs on the Linux PGTK package (Linux-only homes).
# Imports emacs-core for the shared session environment.
{ config, ... }:
let
  inherit (config.flake.lib.custom) ifPackageNotEnabled;
  emacs-core = config.flake.modules.homeManager.emacs-core;
in
{
  flake.modules.homeManager.emacs-doom =
    {
      config,
      osConfig ? { },
      pkgs,
      ...
    }:
    let
      inherit (builtins) getAttr;

      # Linux-only homes: use the PGTK Emacs package directly.
      emacsBase = pkgs.emacs-git-pgtk;
      mkEmacsHomePackages =
        packages:
        let
          filteredPackages = ifPackageNotEnabled config osConfig packages;
        in
        map (packageName: getAttr packageName pkgs) filteredPackages;

      basePackages = mkEmacsHomePackages [
        "mu"
        "ripgrep"
        "git"
        "fd"
        "sqlite"
        "cmake"
        "gnumake"
        "graphviz"
        "gnutls"
        "ffmpeg"
        "imagemagick"
        "binutils"
        "editorconfig-core-c"
        "languagetool"
        "emacs-all-the-icons-fonts"
        "emacs-lsp-booster"
      ];
    in
    {
      imports = [ emacs-core ];

      xdg.configFile."doom" = {
        enable = true;
        source = ./doom-cfg;
        recursive = true;
      };

      programs.emacs = {
        enable = true;
        package = emacsBase;
        extraPackages =
          epkgs: with epkgs; [
            treesit-grammars.with-all-grammars
            vterm
            eat
            magit
            mu4e
            pdf-tools
            all-the-icons-nerd-fonts
          ];
      };

      home.packages = basePackages ++ [
        (pkgs.writeShellScriptBin "refresh-doom" ''
          set -euo pipefail
          doom sync
          systemctl --user daemon-reload
          systemctl --user restart emacs
        '')

        (pkgs.writeShellScriptBin "upgrade-doom" ''
          set -euo pipefail
          doom upgrade
          systemctl --user daemon-reload
          systemctl --user restart emacs
        '')
      ];
    };
}
