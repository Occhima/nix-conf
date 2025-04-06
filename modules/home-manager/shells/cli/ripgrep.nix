{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "ripgrep" cfg.tools) {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
      ];
    };

    # Additional aliases
    home.shellAliases = {
      rg = "rg --pretty";
      rgf = "rg --files | rg";
    };
  };
}
