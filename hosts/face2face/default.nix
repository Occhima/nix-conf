{
  networking.hostName = "face2face";
  modules = {
    system = {
      boot = {
        loader.none.enable = true;
        tmpOnTmpfs = true;
        enableKernelTweaks = true;
        loadRecommendedModules = true;

        initrd = {
          enableTweaks = true;
          optimizeCompressor = true;
        };
      };
      fs = {
        default = true;
        support = [
          "ext4"
          "vfat"
        ];
      };

    };
    hardware = {
      yubikey.enable = true;
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
