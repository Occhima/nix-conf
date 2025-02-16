{

  imports = [ ./disko.nix ];
  networking.hostName = "face2face";
  modules = {
    system = {
      boot = {
        loader.systemd.enable = true;
        tmpOnTmpfs = false;
        enableKernelTweaks = false;
        loadRecommendedModules = true;

        initrd = {
          enableTweaks = false;
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
