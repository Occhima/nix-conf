{ inputs, ... }:
{

  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix

  ];
  networking.hostName = "face2face";
  modules = {
    system = {
      boot = {
        loader.systemd.enable = true;
        tmpOnTmpfs = true;
        enableKernelTweaks = true;
        loadRecommendedModules = true;

        initrd = {
          enableTweaks = true;
          optimizeCompressor = false;
        };
      };

    };
    hardware = {
      yubikey.enable = false;
    };
    secrets = {
      agenix-rekey = {
        enable = true;
        secretsDir = ../secrets/vault;
        hostPublicKey = ../secrets/identity/id_ed25519.pub;
        publicKeys = [ ../secrets/identity/yubi-identity.pub ];
        storageDir = ./rekeyed;
      };

    };
  };

}
