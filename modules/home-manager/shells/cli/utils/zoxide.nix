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
  config = mkIf (cfg.enable && builtins.elem "zoxide" cfg.tools) {
    programs.zoxide = {
      enable = true;
    };
  };
}
