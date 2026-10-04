{ inputs, ... }:
let
  secretsDir = ./vault;
  identityDir = ./identity;
  rekeyedDir = ./rekeyed;
in
{
  flake-file.inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ inputs.agenix-rekey.flakeModule ];

  perSystem = {
    agenix-rekey = {
      collectHomeManagerConfigurations = false;
    };
  };

  flake.modules.nixos.agenix =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkOption
        mkMerge
        mkDefault
        ;
      inherit (lib.strings) optionalString;

      cfg = config.modules.secrets.agenix;
      persist = config.environment.persistence ? "/persist";
      ageSecrets = lib.mapAttrs' (name: _: {
        name = lib.removeSuffix ".age" name;
        value = {
          rekeyFile = secretsDir + "/${name}";
          # All vault secrets are consumed by the main user (shell vars,
          # user services); agenix defaults to root:root 0400 which they
          # cannot read. mkDefault so a host can override per secret.
          owner = mkDefault config.modules.accounts.mainUser;
        };
      }) (lib.filterAttrs (name: _: lib.hasSuffix ".age" name) (builtins.readDir secretsDir));
    in
    {
      imports = [
        inputs.agenix-rekey.nixosModules.default
        inputs.agenix.nixosModules.default
      ];

      options.modules.secrets.agenix = {
        masterKeys = mkOption {
          description = "Paths to master SSH public keys (e.g., YubiKey identities)";
          example = [ "./identity/yubi-identity.pub" ];
          default = [
            (identityDir + "/yubi-id.pub")
          ];
        };
        extraPub = mkOption {
          default = [ ];
          description = "Additional public keys to use for encryption, mostly backup keys";
        };
      };
      config = mkMerge [
        {
          age.rekey.masterIdentities = cfg.masterKeys;
        }
        {
          age = {
            secrets = ageSecrets;

            rekey = {
              storageMode = mkDefault "local";
              localStorageDir = rekeyedDir + "/${config.networking.hostName}";
              extraEncryptionPubkeys = cfg.extraPub;
            };

            identityPaths = [
              "${optionalString persist "/persist"}/etc/ssh/ssh_host_ed25519_key"
            ];
          };
        }
      ];
    };
}
