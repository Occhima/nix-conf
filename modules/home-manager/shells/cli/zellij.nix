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
        default_mode = "vim";
        scrollback_editor = "hx";
        session_serialization = false;
      };
    };
  };
}
