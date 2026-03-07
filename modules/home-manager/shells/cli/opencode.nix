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
  config = mkIf (cfg.enable && builtins.elem "opencode" cfg.tools) {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;

      settings = {
        theme = "dark";
        autoupdate = false;
      };
    };
  };
}
