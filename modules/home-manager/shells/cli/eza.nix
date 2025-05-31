{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "eza" cfg.tools) {
    programs.eza = {
      enable = true;
      icons = "auto";
      # enableAliases = true;

      extraOptions = [
        "--group"
        "--header"
        "--group-directories-first"
        "--time-style=long-iso"
      ];
    };

    # Additional aliases
    home.shellAliases = {
      l = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      ll = "eza -la --git";
    };
  };
}
