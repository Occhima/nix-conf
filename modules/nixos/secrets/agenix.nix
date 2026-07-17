# agenix + agenix-rekey: one feature, several contexts. This file carries
# the flake-level rekey integration AND the NixOS aspect. The secret
# assets live right here (./vault, ./identity, ./rekeyed) so every
# reference is local; each host contributes its own `age.rekey.hostPubkey`
# from a `host.pub` next to its host module and registers itself via
# `perSystem.agenix-rekey.nixosConfigurations.<host>` — no central list.
{ inputs, ... }:
let
  secretsDir = ./vault;
  identityDir = ./identity;
  rekeyedDir = ./rekeyed;
in
{
  imports = [ inputs.agenix-rekey.flakeModule ];

  config.perSystem = _: {
    agenix-rekey = {
      collectHomeManagerConfigurations = false;
    };
  };

  config.occhima.agenix.nixos =
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
      ageSecrets = lib.mapAttrs'
        (name: _: {
          name = lib.removeSuffix ".age" name;
          value = {
            rekeyFile = secretsDir + "/${name}";
            owner = "occhima";
          };
        })
        (lib.filterAttrs (name: _: lib.hasSuffix ".age" name)
          (builtins.readDir secretsDir));

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
          # XXX: This must always be set in agenix-rekey
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
