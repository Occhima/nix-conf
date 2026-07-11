#!/usr/bin/env bash
set -e

C_BG="#1a1b26"
C_FG="#c0caf5"
C_PINK="#ff007c"
C_PURPLE="#bd93f9"
C_CYAN="#00e8c6"
C_GRAY="#414868"

ICON_DISK="󰋊"
ICON_NIX=""
ICON_GIT="󰊢"
ICON_KEY="󰯄"
ICON_CHECK=""
ICON_CROSS=""
ICON_WARN=""
ICON_DOWN="󰇚"

banner() {
  clear
  gum style \
    --border double --border-foreground "$C_PURPLE" --padding "1 2" --margin "1 0" \
    --align center --width 60 \
    "$(gum style --foreground "$C_PINK" --bold "NIXOS DEPLOYMENT")" \
    "$(gum style --foreground "$C_CYAN" "Automated Installation Wizard")"
}

info_box() {
  gum style --foreground "$C_FG" --border normal --border-foreground "$C_GRAY" --padding "0 1" " $1 "
}

exec_task() {
  local title="$1"
  local command="$2"

  echo ""
  gum style --foreground "$C_BG" --background "$C_PURPLE" --bold --padding "0 1" " EXECUTING: $title "
  echo ""

  if eval "$command"; then
    echo ""
    gum style --foreground "$C_BG" --background "$C_CYAN" --bold --padding "0 1" " $ICON_CHECK SUCCESS "
    sleep 1.5
  else
    echo ""
    gum style --foreground "$C_BG" --background "$C_PINK" --bold --padding "0 1" " $ICON_CROSS FAILED "
    gum style --foreground "$C_PINK" "An error occurred in step: $title"

    if gum confirm --selected.background "$C_PINK" "Do you want to abort the script?"; then
      exit 1
    fi
  fi
}

ask_input() {
  gum input --prompt " $1 " --placeholder "$2" --width 50 --cursor.foreground "$C_PINK"
}

ask_confirm() {
  gum confirm "$1" --selected.background "$C_CYAN" --selected.foreground "$C_BG"
}


FLAKE_DIR=${FLAKE_DIR:-"/mnt/etc/nixos"}
ISO_FLAKE_DIR="$HOME/.config/flake"
REPO_URL="https://github.com/Occhima/nix-conf.git"
DISKO_CFG="/tmp/disko-config.nix"
DISKO_URL_DEFAULT="https://raw.githubusercontent.com/Occhima/nix-conf/main/disko-config.nix"

banner

echo "Select steps to execute (SPACE to select/deselect):"
TASKS=$(gum choose --no-limit --height 12 --cursor.foreground "$C_PINK" --selected.foreground "$C_CYAN" \
    "$ICON_GIT  Clone/Update Flake" \
    "$ICON_DOWN  Fetch Disko Config (Separate)" \
    "$ICON_DISK  Run Disko (Partition & Mount)" \
    "$ICON_NIX  Install NixOS (Core)" \
    "$ICON_KEY  Configure SSH Host Key" \
  "$ICON_WARN  Exit")

if [[ -z "$TASKS" || "$TASKS" == *"$ICON_WARN  Exit"* ]]; then
  echo "Exiting..."
  exit 0
fi

IFS=$'\n'
for item in $TASKS; do
  banner

  case "$item" in
    *"Clone/Update Flake"*)
      info_box "Nix Repository Setup"

      TARGET_DIR=$(ask_input "Clone Path >" "$ISO_FLAKE_DIR")
      FLAKE_DIR=$TARGET_DIR

      if [ -d "$TARGET_DIR/.git" ]; then
        if ask_confirm "Directory exists. Update (git pull)?"; then
          exec_task "Updating Repository" "git -C $TARGET_DIR pull"
        fi
      else
        exec_task "Cloning Repository" "git clone $REPO_URL $TARGET_DIR"
      fi
      ;;

    *"Fetch Disko Config"*)
      info_box "Fetch Partition Config"

      URL=$(ask_input "Config URL (Raw) >" "$DISKO_URL_DEFAULT")
      DEST=$(ask_input "Save path >" "$DISKO_CFG")

      exec_task "Downloading Config" "curl -L -o $DEST $URL"
      ;;

    *"Run Disko"*)
      info_box "Disk Partitioning (Disko)"

      echo "Available Disks:"
      lsblk -dno NAME,SIZE,MODEL,TYPE | \
        gum style --border normal --border-foreground "$C_GRAY" --padding "0 1"

      DISK_NAME=$(ask_input "Target Disk Name (e.g., nvme0n1) >" "")
      DISK="/dev/$DISK_NAME"

      if [ ! -b "$DISK" ]; then
        gum style --foreground "$C_PINK" "Disk $DISK not found!"
        sleep 2
        continue
      fi

      CFG_PATH=$(ask_input "Disko Config Path >" "$DISKO_CFG")

      if [ ! -f "$CFG_PATH" ]; then
        gum style --foreground "$C_PINK" "Config file not found at $CFG_PATH"
        if ask_confirm "Do you want to fetch it now?"; then
          URL=$(ask_input "Config URL >" "$DISKO_URL_DEFAULT")
          exec_task "Downloading Config" "curl -L -o $CFG_PATH $URL"
        else
          continue
        fi
      fi

      gum style --foreground "$C_PINK" --bold "$ICON_WARN WARNING: All data on $DISK will be WIPED."
      if ask_confirm "Are you absolutely sure?"; then
        exec_task "Partitioning & Mounting" \
          "DISK=$DISK disko --yes-wipe-all-disks --mode destroy,format,mount $CFG_PATH"
      fi
      ;;

    *"Install NixOS"*)
      info_box "System Installation"

      HOSTNAME=$(ask_input "Machine Hostname >" "nixos")

      if [ ! -f "$FLAKE_DIR/flake.nix" ]; then
        FLAKE_DIR=$(ask_input "Real Flake Path >" "/mnt/etc/nixos")
      fi

      echo "Installation Options:"
      CMD="nixos-install --no-root-password --flake $FLAKE_DIR#$HOSTNAME"

      gum style --foreground "$C_GRAY" "Command: $CMD"

      if ask_confirm "Start NixOS Install (No Partitioning)?"; then
        exec_task "Installing NixOS" "$CMD"
      fi
      ;;

    *"Configure SSH Host Key"*)
      info_box "SSH Setup"

      REMOTE_IP=$(ask_input "Remote IP/Host >" "")
      HOST_NAME=$(ask_input "Flake Hostname >" "nixos")
      DEST_DIR="$FLAKE_DIR/hosts/$HOST_NAME/assets"

      mkdir -p "$DEST_DIR"

      exec_task "Fetching SSH Keys" \
        "ssh-keyscan $REMOTE_IP | grep -o 'ssh-ed25519.*' > $DEST_DIR/host.pub"
      ;;
  esac
done

banner
gum style --foreground "$C_CYAN" --bold "Process Finished Successfully!"
