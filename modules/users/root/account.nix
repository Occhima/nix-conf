# root — NixOS account module. Password login is locked (no password hash);
# root access happens via the authorized SSH key below or sudo from wheel.
{
  flake.modules.nixos.user-root = {
    users.users.root = {
      # Locked password hash: password login is disabled for root.
      hashedPassword = "!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/N9m28W8c9Fs9InErjlNRXCwPe1CR9HafzqjTcSis9"
      ];
    };
  };
}
