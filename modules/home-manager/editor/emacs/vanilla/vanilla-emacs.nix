# emacs-vanilla: standalone Emacs configured with use-package and Elpaca.
# It is an alternative to emacs-doom; import exactly one flavor.
{ config, ... }:
let
  inherit (config.flake.lib.custom) ifPackageNotEnabled;
  emacs-core = config.flake.modules.homeManager.emacs-core;
in
{
  flake.modules.homeManager.emacs-vanilla =
    {
      config,
      osConfig ? { },
      pkgs,
      ...
    }:
    let
      inherit (builtins) getAttr;

      emacsBase = pkgs.emacs30-pgtk;
      mkEmacsHomePackages =
        packages:
        let
          filteredPackages = ifPackageNotEnabled config osConfig packages;
        in
        map (packageName: getAttr packageName pkgs) filteredPackages;

      runtimePackages = mkEmacsHomePackages [
        "binutils"
        "cmake"
        "editorconfig-core-c"
        "fd"
        "ffmpeg"
        "git"
        "gnumake"
        "gnutls"
        "graphviz"
        "imagemagick"
        "languagetool"
        "msmtp"
        "mu"
        "nil"
        "pandoc"
        "ripgrep"
        "sqlite"
      ];
    in
    {
      imports = [ emacs-core ];

      xdg.configFile."emacs" = {
        source = ./vanilla-cfg;
        recursive = true;
      };

      programs.emacs = {
        enable = true;
        package = emacsBase;

        # Native modules are built by Nix; Elpaca owns the regular Lisp
        # package graph declared by use-package in vanilla-cfg.
        extraPackages =
          epkgs: with epkgs; [
            eat
            jinx
            jupyter
            mu4e
            pdf-tools
            treesit-grammars.with-all-grammars
            vterm
          ];
      };

      home.packages = runtimePackages;
    };
}
