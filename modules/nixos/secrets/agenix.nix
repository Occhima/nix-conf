{ ... }:
{
  config.flake.modules.nixos.agenix =
    {
      config,
      lib,
      self,
      inputs,
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
      secretsDir = self + /secrets/vault;
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
          example = [ "../secrets/identity/yubi-identity.pub" ];
          default = [
            (self.outPath + "/secrets/identity/yubi-id.pub")
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
              hostPubkey = builtins.readFile (
                self.outPath + "/hosts/${config.networking.hostName}/assets/host.pub"
              );
              localStorageDir = self.outPath + "/secrets/rekeyed/${config.networking.hostName}";
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
