{ den, nixos, ... }:
{
  den.aspects = {
    sshd = {
      includes = [ (nixos "sshd") ];
      persist.files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };

    graphical.includes = map nixos [
      "graphical"
      "display-wayland"
      "display-portals"
      "quickshell-support"
    ];

    system-base.includes = [
      den.batteries.hostname
    ]
    ++ (map nixos [
      "system-assertions"
      "nix"
      "nixpkgs-config"
      "nh"
      "environment-console"
      "environment-fonts"
      "environment-locale"
      "environment-packages"
    ]);

    workstation.includes =
      (with den.aspects; [
        system-base
        user-root
        graphical
        impermanence
        sshd
      ])
      ++ (map nixos [
        "accounts"
        "ssd"
        "bluetooth"
        "yubikey"
        "input-devices"
        "media-sound-pipewire"
        "media-video"
        "monitors"
        "network"
        "networkmanager"
        "firewall"
        "blocker"
        "boot-grub"
        "boot-kernel"
        "boot-plymouth"
        "agenix"
        "systemd"
        "firmware"
        "appimage"
        "security-auth"
        "security-kernel"
      ]);

    gaming-workstation.includes = [
      den.aspects.workstation
    ]
    ++ (map nixos [
      "steam"
      "oom"
      "nix-ld"
    ]);

    iso-base = {
      includes = [
        den.batteries.hostname
      ]
      ++ (map nixos [
        "iso-boot"
        "iso-fixes"
        "iso-image"
        "iso-networking"
        "iso-nix"
        "iso-programs"
        "iso-space"
      ]);
      nixos.imports = [
        (
          { modulesPath, ... }:
          {
            imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix" ];
          }
        )
      ];
    };
  };
}
