{
  config,
  lib,
  self,
  inputs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkMerge
    mkDefault
    ;
  inherit (lib.strings) optionalString;
  inherit (inputs.haumea.lib) load matchers;

  cfg = config.modules.secrets.agenix;
  persist = config.modules.system.file-system.impermanence.enable;
  secretsDir = self + /secrets/vault;
  ageSecrets = load {
    src = secretsDir;
    loader = [
      (matchers.extension "age" (_ctx: path: { rekeyFile = path; }))
    ];
  };

in
{
  imports = [
    inputs.agenix-rekey.nixosModules.default
    inputs.agenix.nixosModules.default
  ];

  options.modules.secrets.agenix = {
    enable = mkEnableOption "Agenix secret management with auto-rekeying";

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
    (mkIf cfg.enable {
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
    })
  ];

}
