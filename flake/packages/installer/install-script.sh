#!/usr/bin/env bash
set -euo pipefail
export GUM_SPIN_SHOW_OUTPUT=1   # show command output underneath spinners

###############################################################################
# Helper wrappers (ASCII‑only to satisfy strict locales)                      #
###############################################################################
header() {
  # Modern ASCII art logo with rounded borders and a refined subtitle
  gum style \
    --bold \
    --foreground 50 \
    --background 236 \
    --border rounded \
    --border-foreground 39 \
    --align center \
    --width 80 \
    --margin "1 3" \
    --padding "1 4" \
    "   __  __ _  _  ___  ____   " \
    "  |  \/  | || ||_ _||  _ \  " \
    "  | |\/| | || | | | | | | | " \
    "  |_|  |_|_||_| |_| | |_| |_|" \
    "" \
    "★ GitHub Inspired NixOS Deployment Wizard ★" \
    "Clone   |   Partition   |   Install   |   Update"

}

spinner() {
  # Usage: spinner "Title" "cmd && ..." ; never aborts main script
  local title="$1" cmd="$2"
  gum spin --spinner dot --show-output --title "$title" -- bash -c "${cmd}; exit 0"
}

trap 'gum log --level error "Interrupted – cleaning up"; exit 130' INT

###############################################################################
# Splash screen & defaults                                                    #
###############################################################################
header "★  NixOS Deployment Wizard  ★" "Partition | Clone | Install | Update"

F_REPO="https://github.com/Occhima/nix-conf.git"
FLAKE_DIR=${FLAKE_DIR:-"$HOME/Projects/nix-conf"}
DEFAULT_DISKO_CFG="/tmp/disko-config.yaml"

###############################################################################
# Task picker (multi‑select)                                                  #
###############################################################################
TASKS=(
  "Clone flake"
  "Partition disk"
  "Install NixOS"
  "Install Doom Emacs"
  "Copy host SSH key"
  "Quit"
)

# multi‑select tips: ↑/↓ move | SPACE toggle | ENTER confirm
chosen=$(printf "%s\n" "${TASKS[@]}" | \
         gum choose --no-limit \
                    --header "Select task(s) to run (SPACE to toggle, ENTER to confirm)" )

if [ -z "$chosen" ]; then
  gum log --level error "Nothing selected – exiting"; exit 1;
fi

###############################################################################
# Main loop: iterate line‑by‑line so items containing spaces stay intact
###############################################################################
IFS=$'\n'  # treat each newline‑separated line as one item, even if it has spaces
for task in $chosen; do
  case "$task" in

  ################################ Clone flake ################################
  "Clone flake")
    FLAKE_DIR=$(gum input --prompt "Clone directory > " --value "$FLAKE_DIR")
    [ -z "$FLAKE_DIR" ] && { gum log --level error "Directory path required"; exit 1; }

    if [[ -d "$FLAKE_DIR/.git" ]]; then
      if gum confirm "Directory exists. Run git pull instead?"; then
        spinner "Updating flake" "git -C \"$FLAKE_DIR\" pull"
      else
        gum log --level warn "Skipped update"
      fi
    else
      spinner "Cloning flake" "git clone \"$F_REPO\" \"$FLAKE_DIR\""
    fi
    ;;

  ############################### Partition disk ##############################
  "Partition disk")
    drv_info=$(lsblk -dno NAME,SIZE | gum choose --header "Choose drive (NAME SIZE)")
    [ -z "$drv_info" ] && { gum log --level warn "No drive chosen. Skipping."; continue; }
    drv="/dev/${drv_info%% *}"

    cfg=$(gum input --prompt "Path to disko config > " --value "$DEFAULT_DISKO_CFG")
    [ ! -f "$cfg" ] && { gum log --level error "Config not found: $cfg"; exit 1; }

    if gum confirm "Run disko on $drv with $cfg? This will DESTROY data."; then
      spinner "Partitioning & mounting" \
        "sudo DISK=$drv disko --yes-wipe-all-disks --mode destroy,format,mount \"$cfg\""
    else
      gum log --level warn "Partition step skipped"
    fi
    ;;

  ############################### Install NixOS ###############################
  "Install NixOS")
    host=$(gum input --prompt "Hostname > " --value "$(hostname)")
    [ -z "$host" ] && { gum log --level error "Hostname required"; exit 1; }

    flake=$(gum input --prompt "Flake directory > " --value "$FLAKE_DIR")
    [ -z "$flake" ] && { gum log --level error "Flake path required"; exit 1; }

    # Pre‑flight flake check
    if gum confirm "Run 'nix flake check' before installation?"; then
      spinner "Running flake checks" "nix flake check \"$flake\" --no-build"
    fi

    # Partition via flake
    if gum confirm "Partition disks for $host using the flake layout? This DESTROYS data."; then
      spinner "Partitioning disks" \
        "sudo disko --yes-wipe-all-disks --mode destroy,format,mount --flake \"$flake#$host\""
    else
      gum log --level warn "Disko partitioning skipped. Ensure disks are ready."
    fi

    # Install
    if gum confirm "Run nixos-install for $host?"; then
      spinner "Installing NixOS" \
        "sudo nixos-install --no-channel-copy --no-root-password --flake \"$flake#$host\""
    else
      gum log --level warn "nixos-install skipped"
    fi
    ;;

  ############################ Install Doom Emacs #############################
  "Install Doom Emacs")
    if gum confirm "Install/overwrite Doom Emacs in ~/.config?"; then
      spinner "Installing Doom Emacs" \
        "rm -rf ~/.config/emacs ~/.config/doom && \
         git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs && \
         git clone https://github.com/Occhima/doom ~/.config/doom && \
         ~/.config/emacs/bin/doom install --force"
    else
      gum log --level warn "Skipped Doom installation"
    fi
    ;;

  ############################ Copy host SSH key ##############################
  "Copy host SSH key")
    addr=$(gum input --prompt "Remote host/IP > ")
    hname=$(gum input --prompt "Destination hostname entry > ")
    [ -z "$addr$hname" ] && { gum log --level error "Both fields required"; exit 1; }

    dest="$FLAKE_DIR/hosts/$hname/assets"; mkdir -p "$dest"
    spinner "Fetching SSH key" \
      "ssh-keyscan \"$addr\" | grep -o 'ssh-ed25519.*' > \"$dest/host.pub\""

    if [[ -s "$dest/host.pub" ]]; then
      gum log --level info "Key saved -> $dest/host.pub"
    else
      gum log --level error "Failed to grab key from $addr"; exit 1
    fi
    ;;

  "Quit") exit 0 ;;
  esac
done

unset IFS  # restore default word splitting

header "All selected tasks completed. You can reboot now."
