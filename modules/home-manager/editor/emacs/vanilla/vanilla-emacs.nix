{ config, ... }:
let
  inherit (config.flake.lib.custom) isWayland;
in
{
  occhima.emacs.homeManager = (
    {
      config,
      osConfig ? { },
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkIf;
      cfg = config.modules.editor.emacs;

      emacsBase = if isWayland osConfig then pkgs.emacs-git-pgtk else pkgs.emacs-git;

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
      config = mkIf (cfg.flavor == "vanilla") {
        home = {
          sessionVariables.EMACSDIR = "${config.xdg.configHome}/emacs";
        };

        programs.emacs = {
          enable = true;
          package = emacsPackageWithPkgs;
        };
      };
    }
  );
}
