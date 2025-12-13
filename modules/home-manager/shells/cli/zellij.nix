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
  config = mkIf (cfg.enable && builtins.elem "zellij" cfg.tools) {
    programs.zellij = {
      enable = true;
      settings = {
        session_serialization = false;
      };
    };
  };
}
