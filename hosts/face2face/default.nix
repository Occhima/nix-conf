{
  imports = [ ./hardware.nix ];
  config = {

    networking.hostName = "face2face";
    modules = {
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
