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
  # GPG is always enabled as a core tool
  config = {
    programs.gpg = {
      enable = true;
      settings = {
        trust-model = "tofu+pgp";
        default-key = "0x0000000000000000"; # Replace with your key
      };
    };

    # GPG agent enabled when cli module is enabled
    services.gpg-agent = mkIf cfg.enable {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 3600;
      maxCacheTtl = 86400;
    };
  };
}
