# emacs-vanilla: use-package driven Emacs on the Linux PGTK package
# (Linux-only homes). Imports emacs-core for the shared session environment.
# Never import together with emacs-doom.
{ config, ... }:
let
  emacs-core = config.flake.modules.homeManager.emacs-core;
in
{
  flake.modules.homeManager.emacs-vanilla =
    {
      lib,
      pkgs,
      ...
    }:
    let
      # Linux-only homes: use the PGTK Emacs package directly.
      emacsBase = pkgs.emacs-git-pgtk;

      readRecursively =
        dir:
        builtins.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: value:
            if value == "regular" then
              builtins.readFile (dir + "/${name}")
            else
              (if value == "directory" then readRecursively (dir + "/${name}") else "")
          ) (builtins.readDir dir)
        );

      emacsPackageWithPkgs = pkgs.emacsWithPackagesFromUsePackage {
        config = readRecursively ./vanilla-cfg;
        alwaysEnsure = true;
        package = emacsBase;
        extraEmacsPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
          epkgs.vterm
          epkgs.eat
          epkgs.magit
          epkgs.mu4e
          epkgs.pdf-tools
          epkgs.all-the-icons-nerd-fonts
        ];
      };
    in
    {
      imports = [ emacs-core ];

      programs.emacs = {
        enable = true;
        package = emacsPackageWithPkgs;
      };
    };
}
