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
    ;
  inherit (lib.types) path listOf;
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
      type = listOf path;
      description = "Paths to master SSH public keys (e.g., YubiKey identities)";
      example = [ "../secrets/identity/yubi-identity.pub" ];
      default = [ (self.outPath + "/hosts/steammachine/assets/yubi-identity.pub") ];
    };

    extraPub = mkOption {
      type = listOf path;
      default = [ ];
      description = "Directory containing .age encrypted secrets";
    };
  };
  config = mkMerge [
    {
      # XXX: This must always be set
      age.rekey.masterIdentities = cfg.masterKeys;
    }
    (mkIf cfg.enable {
      age = {
        secrets = ageSecrets;

        rekey = {
          storageMode = "local";
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
