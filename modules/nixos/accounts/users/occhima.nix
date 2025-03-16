{
  initialPassword = "changeme";
  isNormalUser = true;

  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/N9m28W8c9Fs9InErjlNRXCwPe1CR9HafzqjTcSis9"
  ];

  extraGroups = [
    "networkmanager"
    "systemd-journal"
    "audio"
    "video"
    "input"
    "nix"
    "docker"
    "wheel" # For sudo access
  ];
}
