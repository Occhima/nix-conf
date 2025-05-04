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
  config = mkIf (cfg.enable && builtins.elem "ssh" cfg.tools) {
    programs.ssh = {
      enable = true;
      hashKnownHosts = true;
      compression = true;
      # TODO...
      # matchBlocks = {
      #   "github.com" = mkIf hasAgeKeys {
      #     user = "git";
      #     hostname = "github.com";
      #     identityFile = osConfig.age.secrets.github.path;
      #   };
      # };
    };
  };
}
