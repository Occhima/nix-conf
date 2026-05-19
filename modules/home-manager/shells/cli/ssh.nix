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
      enableDefaultConfig = false;
      settings."*" = {
        HashKnownHosts = true;
        Compression = true;
      };

      # TODO...
      # settings."github.com" = mkIf hasAgeKeys {
      #   User = "git";
      #   HostName = "github.com";
      #   IdentityFile = osConfig.age.secrets.github.path;
      # };
    };
  };
}
