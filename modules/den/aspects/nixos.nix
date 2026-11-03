{ config, den, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  den.aspects = {
    graphical.nixos.imports = with nixos; [
      graphical
      display-wayland
      display-portals
      quickshell-support
    ];

    laptop.nixos.imports = [ nixos.laptop ];

    headless.nixos.imports = [ nixos.headless ];

    wsl.nixos.imports = [ nixos.wsl ];

    system-base.includes = [ den.batteries.hostname ];
    system-base.nixos.imports = with nixos; [
      system-assertions
      nix
      nixpkgs-config
      nh
      environment-console
      environment-fonts
      environment-locale
      environment-packages
    ];

    workstation = {
      includes = with den.aspects; [
        system-base
        user-root
        graphical
      ];
      nixos.imports = with nixos; [
        accounts
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
        boot-grub
        boot-kernel
        boot-plymouth
        impermanence
        agenix
        systemd
        firmware
        sshd
        appimage
        security-auth
        security-kernel
      ];
    };

    gaming-workstation = {
      includes = [ den.aspects.workstation ];
      nixos.imports = with nixos; [
        steam
        oom
        nix-ld
      ];
    };

    iso-base.includes = [ den.batteries.hostname ];
    iso-base.nixos.imports = with nixos; [
      iso-boot
      iso-fixes
      iso-image
      iso-networking
      iso-nix
      iso-programs
      iso-space
      (
        { modulesPath, ... }:
        {
          imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix" ];
        }
      )
    ];
  };
}
