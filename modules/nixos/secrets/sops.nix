# im probably ditching sops and will use agenix
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.secrets.sops;
in
{
  options.modules.sops = {
    enable = mkEnableOption "SOPS secret management";

    defaultSopsFile = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.config/sops/secrets.yaml";
      description = "Default SOPS secrets file location";
    };

  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

  };
}
