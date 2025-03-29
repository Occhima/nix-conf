#!/usr/bin/env bash
export GUM_SPIN_SHOW_OUTPUT=1

gum style \
  --foreground 212 --border-foreground 212 --border double \
  --align center --width 50 --margin "1 2" --padding "2 4" \
  'NixOS Deployment Wizard' 'Partition, Clone, Install & Update with Ease!'

selected_tasks=$(gum choose \
    "Clone the flake" \
    "Partition Disk" \
    "Install NixOS" \
    "Install Doom" \
  "Quit")

[ -z "$selected_tasks" ] && { gum log --structured --level error "No tasks selected. Exiting."; exit 1; }

case "$selected_tasks" in

  "Clone the flake")
    dest_path=$(gum input --placeholder "Enter destination path for flake clone (e.g., /tmp/nix-conf)")
    [ -z "$dest_path" ] && { gum log --structured --level error "Destination path is required."; exit 1; }
    gum log --structured --level info "Cloning flake repository into $dest_path..."
    gum spin --spinner dot --title "Cloning flake repository..." -- \
      git clone https://github.com/Occhima/nix-conf.git "$dest_path" || {
      gum log --structured --level error "Clone failed! Check network/repo URL."
      exit 1
    }
    gum log --structured --level info "Flake repository cloned successfully."
    ;;

  "Partition Disk")
    drive=$(lsblk -nlo PATH | gum choose --header "Select drive to partition")
    [ -z "$drive" ] && { gum log --structured --level error "No drive selected. Exiting."; exit 1; }
    disko_config=$(gum input --placeholder "Enter path to disko config file (e.g., /tmp/disko-config.yaml)")
    [ -z "$disko_config" ] && { gum log --structured --level warn "No disko config provided. Using default: /tmp/disko-config.yaml"; disko_config="/tmp/disko-config.yaml"; }
    [ ! -f "$disko_config" ] && { gum log --structured --level error "Disko config file not found at $disko_config"; exit 1; }
    gum log --structured --level info "Partitioning disk using disko config $disko_config..."
    gum spin --spinner dot --title "Partitioning disk..." -- \
      gum confirm && disko --mode destroy,format,mount "$disko_config" || echo "User declined disk partitioning"
    gum log --structured --level info "Disk partitioning completed."
    ;;

  "Install NixOS")
    hostname=$(gum input --placeholder "Enter hostname for NixOS installation")
    [ -z "$hostname" ] && { gum log --structured --level error "Hostname is required."; exit 1; }
    gum log --structured --level info "Starting NixOS installation using disko-install..."

    gum spin --spinner dot --title "Cloning flake repository..." -- \
      git clone https://github.com/Occhima/nix-conf.git /etc/nixos || {
      gum log --structured --level error "Clone failed! Check network/repo URL."
      exit 1
    }

    gum spin --spinner dot --title "Installing NixOS..." -- \
      gum confirm && disko-install --flake "/etc/nixos#${hostname}" --no-channel-copy |& nom || echo "User declined disko-install"
    gum log --structured --level info "NixOS installation completed."
    ;;

  "Install Doom")
    gum log --structured --level info "Installing Doom Emacs..."
    gum log --structured --level info "Removing old emacs config dir..."
    rm -rf ~/.config/emacs
    gum spin --spinner dot --title "Cloning Doom config..." -- \
      git clone https://github.com/Occhima/doom.git ~/.config/doom
    gum spin --spinner dot --title "Cloning Doom Emacs..." -- \
      git clone --depth 1 https://github.com/doomemacs/doomemacs.git ~/.config/emacs
    gum spin --spinner dot --title "Running Doom install..." -- \
      ~/.config/emacs/bin/doom install --force
    gum log --structured --level info "Doom Emacs installation completed."
    ;;

  "Quit")
    gum log --structured --level info "Quitting installer."
    exit 0
    ;;
esac

gum log --structured --level info "All selected tasks have been completed."
