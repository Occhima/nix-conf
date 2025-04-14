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
  config = mkIf (cfg.enable && builtins.elem "ssh" cfg.tools) {
    programs.ssh = {
      enable = true;
      hashKnownHosts = true;
      compression = true;
    };
  };
}
