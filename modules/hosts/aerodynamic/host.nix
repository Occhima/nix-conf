# Host: aerodynamic — laptop, Intel/NVIDIA, Greetd, Disko, impermanence.
{ config, inputs, ... }:
{
  flake.modules.nixos.aerodynamic = {
    imports = with config.flake.modules.nixos; [
      system-base
      accounts
      user-occhima
      user-root
      cpu-intel
      gpu-nvidia
      ssd
      bluetooth
      yubikey
      input-devices
      media-sound-pipewire
      media-video
      monitors
      network
      networkmanager
      firewall
      blocker
      wireless
      boot-grub
      boot-kernel
      boot-plymouth
      display-wayland
      display-portals
      login-greetd
      impermanence
      disko-aerodynamic
      docker
      podman
      agenix
      systemd
      firmware
      flatpak
      ssh
      appimage
      security-auth
      security-kernel
      laptop
      graphical
      desktop
    ];
    config = {
      modules.network.hostName = "aerodynamic";

      # agenix-rekey host identity lives next to the host, not in a registry.
      age.rekey.hostPubkey = builtins.readFile ./host.pub;
      modules.hardware.monitors = {
        primaryMonitorName = "edp1";
        displays.edp1 = {
          output = "eDP-1";
          mode = "2560x1080@180";
          position = "0x0";
        };
      };
      modules.system.boot.loader.grub.device = "/dev/nvme0n1";
    };
  };

  flake.nixosConfigurations.aerodynamic = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config.flake.modules.nixos.aerodynamic ];
  };

  perSystem = _: {
    agenix-rekey.nixosConfigurations.aerodynamic = config.flake.nixosConfigurations.aerodynamic;
  };
}
