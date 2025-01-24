{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.sops;
in
{
  options.modules.sops = {
    enable = mkEnableOption "SOPS secret management";

    defaultSopsFile = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.config/sops/secrets.yaml";
      description = "Default SOPS secrets file location";
    };

    age = {
      enable = mkEnableOption "age key support for SOPS";
      keyFile = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        description = "Age private key file location";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    home.activation = {
      setupSops = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.config/sops/age
        if [ ! -f "${cfg.age.keyFile}" ] && [ "${toString cfg.age.enable}" = "true" ]; then
          ${pkgs.age}/bin/age-keygen -o "${cfg.age.keyFile}"
          chmod 600 "${cfg.age.keyFile}"
          echo "SOPS age key generated at ${cfg.age.keyFile}"
        fi
      '';
    };
  };
}
