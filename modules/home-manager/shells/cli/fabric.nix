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
  config = mkIf (cfg.enable && builtins.elem "fabric-ai" cfg.tools) {

    programs.fabric-ai = {
      enable = true;
      enableYtAlias = true;
      enablePatternAlias = true;
    };
  };
}
