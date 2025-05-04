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
  config = mkIf (cfg.enable && builtins.elem "fastfetch" cfg.tools) {
    programs.fastfetch = {
      enable = true;
    };

    home.shellAliases = {
      ff = "fastfetch";
    };
  };
}
