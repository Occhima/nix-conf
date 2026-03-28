{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) ifPackageNotEnabled isWayland;
  inherit (builtins) getAttr;

  cfg = config.modules.editor.emacs;
  emacsBase = if isWayland osConfig then pkgs.emacs-git-pgtk else pkgs.emacs-git;
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
  config = mkIf (cfg.enable && cfg.flavor == "doom") {
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
