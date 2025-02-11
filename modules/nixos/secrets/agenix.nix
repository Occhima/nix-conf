{
  config,
  lib,
  inputs,
  options,
  pkgs,
  ...
}:

with builtins;
with lib;
with lib.types;
let

  # Idea stole from: https://github.com/edmundmiller/dotfiles/blob/84190c0606fb1def68be92926c33623ce9f2f81a/modules/agenix.nix
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
    secretsDir = mkOption {
      type = path;
      default = [ ];
      example = [ "./secrets" ];
      description = "A director containing .age secrets and secrets.nix";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          let
            secretsFile = "${cfg.secretsDir}/secrets.nix";
          in
          pathExists secretsFile;
        message = "modules.secrets.agenix: secrets.nix file not found in ${cfg.secretsDir}";
      }
    ];

    environment.systemPackages = [ pkgs.age ];
    age = {
      secrets =
        let
          secretsFile = "${cfg.secretsDir}/secrets.nix";
        in
        mapAttrs' (
          n: _:
          nameValuePair (removeSuffix ".age" n) {
            file = "${cfg.secretsDir}/${n}";
            owner = "occhima";
          }
        ) (import secretsFile);
      identityPaths = concatLists [
        cfg.identityPaths
        options.age.identityPaths.default
      ];
    };

  };
}
