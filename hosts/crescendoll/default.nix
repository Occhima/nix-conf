{
  config = {
    networking.hostName = "crescendoll";
    modules = {
      profiles = {
        enable = true;
        active = [
          "wsl"
          "headless"
        ];
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
  };
}
