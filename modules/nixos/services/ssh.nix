{ lib, config, ... }:

# Based on https://github.com/isabelroses/dotfiles/blob/566638959f71566a5837f68c5754534776174242/modules/nixos/networking/ssh.nix#L11
{
  options.modules.services.ssh.enable = lib.mkEnableOption "SSH service";

  config = lib.mkIf config.modules.services.ssh.enable {
    services.openssh = {
      enable = true;

      startWhenNeeded = lib.mkForce false;
      allowSFTP = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";
        ChallengeResponseAuthentication = "no";
        UsePAM = false;
        UseDns = false;
        X11Forwarding = false;
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
        ClientAliveCountMax = 5;
        ClientAliveInterval = 60;

        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "diffie-hellman-group-exchange-sha256"
          "mlkem768x25519-sha256"
          "sntrup761x25519-sha512"
        ];

        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
      };

      openFirewall = true;
      ports = [ 22 ];

      hostKeys = [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
