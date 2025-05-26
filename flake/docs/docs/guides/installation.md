# Installation Guide

This guide walks you through installing NixOS using this configuration.

## Prerequisites

- A NixOS installation medium (USB drive or CD/DVD)
- Basic knowledge of Linux and the command line
- Familiarity with Nix and NixOS concepts

## Installing from Scratch

### 1. Boot from NixOS Installation Medium

Boot your system from the NixOS installation medium. Once booted, you'll be presented with a shell.

### 2. Set Up Network

Ensure your network connection is working:

```bash
ip a  # Check network interfaces
ping -c 3 google.com  # Verify internet connectivity
```

If needed, connect to a wireless network:

```bash
wpa_supplicant -B -i wlp3s0 -c <(wpa_passphrase "SSID" "PASSWORD")
```

### 3. Partition Your Disk

This configuration supports several disk setup methods:

#### Using disko (Recommended)

The repository includes disko configurations for automatic partitioning:

```bash
# Clone the repository
git clone https://github.com/occhima/nixos.git ~/.config/nixos

# Navigate to the configuration
cd ~/.config/nixos

# Use disko to partition and format the disk
# Replace 'hostname' with the desired host configuration
# Replace '/dev/sdX' with your target disk
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount hosts/hostname/disko.nix /dev/sdX
```

#### Manual Partitioning

If you prefer to partition manually:

```bash
# List disks
lsblk

# Create partition table (example for GPT)
parted /dev/sdX -- mklabel gpt

# Create EFI partition
parted /dev/sdX -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sdX -- set 1 esp on

# Create root partition
parted /dev/sdX -- mkpart primary 512MiB 100%

# Format partitions
mkfs.fat -F 32 -n boot /dev/sdX1
mkfs.ext4 -L nixos /dev/sdX2

# Mount partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

### 4. Clone the Repository

Once your disk is partitioned and mounted, clone this repository:

```bash
mkdir -p /mnt/home/your-username/.config
git clone https://github.com/occhima/nixos.git /mnt/home/your-username/.config/nixos
cd /mnt/home/your-username/.config/nixos
```

### 5. Install NixOS

#### Using just

If your system already has `just` and `nix` with flakes enabled:

```bash
# Replace 'hostname' with your desired host
just classic-install hostname
```

#### Using disko-install (with automatic partitioning)

For complete automation including partitioning:

```bash
# Replace parameters with your values
just partition-install hostname disk-name /dev/sdX
```

#### Using nixos-install directly

```bash
# Replace 'hostname' with your desired host
sudo nixos-install --flake .#hostname
```

### 6. Set Root Password

After installation completes:

```bash
sudo nixos-enter --root /mnt
passwd  # Set root password
exit
```

### 7. Reboot

```bash
reboot
```

## Post-Installation

After rebooting into your new system:

### 1. Login as Root

Log in with the root password you set earlier.

### 2. Create Your User

If you didn't configure a user in your NixOS configuration:

```bash
useradd -m -G wheel -s /bin/bash your-username
passwd your-username
```

### 3. Configure Your System

Navigate to your configuration directory:

```bash
cd /home/your-username/.config/nixos
```

Modify the configuration as needed for your system:

- Edit host-specific configurations in `hosts/hostname/`
- Configure your user in `home/your-username/`

### 4. Apply Configuration

Apply your configuration changes:

```bash
just switch  # Apply system configuration
just home-switch  # Apply home-manager configuration
```

## Troubleshooting

If you encounter issues during installation:

- Check your network connectivity
- Verify disk partitioning with `lsblk` and `mount`
- Review NixOS installation logs in `/var/log/nixos-install.log`
- If using disko, check for partition errors with `dmesg`

For more detailed troubleshooting, refer to the [NixOS Wiki](https://nixos.wiki/wiki/NixOS_Installation_Guide).
