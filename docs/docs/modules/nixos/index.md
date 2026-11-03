# NixOS Aspects

Every file under `modules/nixos/` (plus `modules/iso/`) contributes a named aspect to
`flake.modules.nixos.<aspect>`. Importing an aspect activates it — none of
them carry an `enable` switch. Options that remain hold genuine data
(monitor layout, boot device, main user, secrets metadata).

## Aspect families

| Area           | Aspects (examples)                                                                                                                                              |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Base           | `system-assertions`, `nix`, `nixpkgs-config`, `nh`, `environment-*`                                                                                             |
| Accounts       | `accounts` (policy + HM wiring)                                                                                                                                 |
| Hardware       | `cpu-amd`, `cpu-intel`, `gpu-nvidia`, `gpu-amd`, `gpu-intel`, `bluetooth`, `yubikey`, `ssd`, `monitors`, `media-sound-pipewire`, `media-video`, `input-devices` |
| Network        | `network`, `networkmanager`, `firewall`, `blocker`, `wireless`, `vpn-openvpn`, `vpn-tailscale`                                                                  |
| Boot & display | `boot-grub`, `boot-kernel`, `boot-plymouth`, `secure-boot`, `display-wayland`, `display-x11`, `display-portals`, `login-ly`, `login-greetd`, `login-sddm`       |
| Storage        | `disko-base`, `disko-<host>`, `impermanence`                                                                                                                    |
| Security       | `security-auth`, `security-kernel`, `apparmor`, `auditd`, `clamav`                                                                                              |
| Services       | `ssh`, `steam`, `systemd`, `oom`, `firmware`, `flatpak`, `appimage`, `nix-ld`                                                                                   |
| Virtualisation | `podman`, `docker`, `distrobox`, `qemu`, `vm`, `microvm`, `pentesting-container`                                                                                |
| Secrets        | `agenix` (hosts add their own `age.rekey.hostPubkey`)                                                                                                           |
| Roles          | `graphical`, `laptop`, `headless`, `wsl`                                                                                                                        |

## Writing a new aspect

```nix
# modules/nixos/services/foo.nix
{ ... }:
{
  config.flake.modules.nixos.foo =
    { pkgs, ... }:
    {
      services.foo.enable = true;   # native NixOS options are normal payload
    };
}
```

Cross-context features define several classes in the same file
(`flake.modules.nixos.foo` + `flake.modules.homeManager.foo`).

Groupings (`system-base`, `workstation`, `gaming-workstation`, `iso-base`)
and users (`occhima`, `user-root`) are Den aspects under `modules/den/aspects/`.
