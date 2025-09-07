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
  config = mkIf (cfg.enable && builtins.elem "navi" cfg.tools) {
    programs.navi = {
      enable = true;
    };
  };
}
