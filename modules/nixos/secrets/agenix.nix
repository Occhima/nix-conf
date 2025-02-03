{
  config,
  lib,
  inputs,
  ...
}:

with lib;
with lib.types;
let
  cfg = config.modules.secrets.agenix;
in
{
  imports = [
    inputs.agenix.nixosModules.age # Bring in original agenix options
  ];

  options.modules.secrets.agenix = {
    enable = mkEnableOption "Agenix secret management";

    identityPaths = mkOption {
      type = listOf path;
      default = [ ];
      example = [ "/etc/ssh/ssh_host_ed25519_key" ];
      description = "SSH keys for decryption";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      age.identityPaths = cfg.identityPaths;

      assertions = [
        {
          assertion = cfg.identityPaths != [ ];
          message = "Must specify identityPaths when using agenix";
        }
      ];
    })
  ];
}
