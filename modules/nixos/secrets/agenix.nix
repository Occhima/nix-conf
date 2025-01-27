# modules/security/agenix/default.nix
{
  config,
  lib,
  inputs,
  ...
}:

with lib;

let
  cfg = config.modules.secrets.agenix;
  mapSecrets = secretsDir: secretsDir;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  options.modules.security.agenix = {
    enable = mkEnableOption "Agenix secret management";

    secretsDirectory = mkOption {
      type = types.str;
      description = "Directory where decrypted secrets will be stored";
    };
    identityPaths = mkOption {
      type = types.listOf types.path;
      default = [ ];
      example = [ "~/.ssh/id_ed25519" ];
      description = ''
        List of paths to SSH identities to use for rekeying.
        These should be private keys that correspond to the public keys used
        to encrypt the secrets.
      '';
    };

    rekey = {
      enable = mkEnableOption "Automatic rekeying of secrets";
    };
  };

  config = mkIf cfg.enable {
    age = {
      secretsDir = mapSecrets cfg.secretsDirectory;
      identityPaths = cfg.identityPaths;

      # TODO...
      rekey = mkIf cfg.rekey.enable { };
    };

  };
}
