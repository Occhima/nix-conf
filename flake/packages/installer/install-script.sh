#!/usr/bin/env bash
set -euo pipefail
export GUM_SPIN_SHOW_OUTPUT=1   # show command output underneath spinners

###############################################################################
# Helper wrappers (ASCII‑only to satisfy strict locales)                      #
###############################################################################
PALETTE_ACCENT=212
PALETTE_INFO=45
PALETTE_MUTED=243
PALETTE_BORDER=39
PALETTE_TITLE=214

header() {
  # Modern ASCII art logo with rounded borders and a refined subtitle
  local title="${1:-NixOS Deployment Wizard}"
  local subtitle="${2:-Clone | Partition | Install | Update}"
  gum style \
    --bold \
    --foreground 50 \
    --background 236 \
    --border rounded \
    --border-foreground "$PALETTE_BORDER" \
    --align center \
    --width 100 \
    " _______  .__       ________                     .___                 __         .__  .__      __                .__          " \
    " \      \ |__|__  __\_____  \   ______           |   | ____   _______/  |______  |  | |  |   _/  |_  ____   ____ |  |   ______ " \
    " /   |   \|  \  \/  //   |   \ /  ___/   ______  |   |/    \ /  ___/\   __\__  \ |  | |  |   \   __\/  _ \ /  _ \|  |  /  ___/ " \
    "/    |    \  |>    </    |    \\\___ \   /_____/  |   |   |  \\\___ \  |  |  / __ \|  |_|  |__  |  | (  <_> |  <_> )  |__\___ \  " \
    "\____|__  /__/__/\_ \_______  /____  >           |___|___|  /____  > |__| (____  /____/____/  |__|  \____/ \____/|____/____  > " \
    "        \/         \/       \/     \/                     \/     \/            \/                                          \/  " \
    "" \
    "$(gum style --foreground "$PALETTE_TITLE" --bold "$title")" \
    "$(gum style --foreground 110 "$subtitle")"
}

spinner() {
  # Usage: spinner "Title" "cmd && ..." ; never aborts main script
  local title="$1" cmd="$2"
  gum spin --spinner dot --show-output --title "$title" -- bash -c "${cmd}; exit 0"
}

section() {
  gum style --foreground "$PALETTE_INFO" --bold --border normal --border-foreground "$PALETTE_BORDER" --padding "0 1" "$1"
}

divider() {
  gum style --foreground "$PALETTE_MUTED" --faint "────────────────────────────────────────────────────────────"
}

confirm() {
  gum confirm --prompt "$(gum style --foreground "$PALETTE_ACCENT" --bold "$1")"
}

prompt() {
  gum input --prompt "$(gum style --foreground "$PALETTE_ACCENT" --bold "$1")"
}

trap 'gum log --level error "Interrupted – cleaning up"; exit 130' INT

###############################################################################
# Splash screen & defaults                                                    #
###############################################################################
header "NixOS Deployment Wizard" "Clone | Partition | Install | Update"

F_REPO="https://github.com/Occhima/nix-conf.git"
P_REPO="https://github.com/Occhima/pass-conf.git"
FLAKE_DIR=${FLAKE_DIR:-"$HOME/.config/flake"}
PASSAGE_DIR=${PASSAGE_DIR:-"$HOME/.passage"}
DEFAULT_DISKO_CFG="/tmp/disko-config.yaml"

###############################################################################
# Task picker (multi‑select)                                                  #
###############################################################################
TASKS=(
  "Clone flake"
  "Partition disk"
  "Install NixOS"
  "Install Doom Emacs"
  "Get password vault"
  "Copy host SSH key"
  "Get nixGL"
  "Quit"
)

# multi‑select tips: ↑/↓ move | SPACE toggle | ENTER confirm
chosen=$(printf "%s\n" "${TASKS[@]}" | \
    gum choose --no-limit \
  --header "$(gum style --foreground "$PALETTE_ACCENT" --bold "Select task(s) to run")  $(gum style --foreground "$PALETTE_MUTED" "SPACE toggle · ENTER confirm")" )

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
      section "Clone flake"
      divider
      FLAKE_DIR=$(prompt "Clone directory > " --value "$FLAKE_DIR")
      [ -z "$FLAKE_DIR" ] && { gum log --level error "Directory path required"; exit 1; }

      if [[ -d "$FLAKE_DIR/.git" ]]; then
        if confirm "Directory exists. Run git pull instead?"; then
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
      section "Partition disk"
      divider
      drv_info=$(lsblk -dno NAME,SIZE | gum choose --header "Choose drive (NAME SIZE)")
      [ -z "$drv_info" ] && { gum log --level warn "No drive chosen. Skipping."; continue; }
      drv="/dev/${drv_info%% *}"

      cfg=$(prompt "Path to disko config > " --value "$DEFAULT_DISKO_CFG")
      [ ! -f "$cfg" ] && { gum log --level error "Config not found: $cfg"; exit 1; }

      if confirm "Run disko on $drv with $cfg? This will DESTROY data."; then
        spinner "Partitioning & mounting" \
          "sudo DISK=$drv disko --yes-wipe-all-disks --mode destroy,format,mount \"$cfg\""
      else
        gum log --level warn "Partition step skipped"
      fi
      ;;

      ############################### Install NixOS ###############################
    "Install NixOS")
      section "Install NixOS"
      divider
      host=$(prompt "Hostname > " --value "$(hostname)")
      [ -z "$host" ] && { gum log --level error "Hostname required"; exit 1; }

      flake=$(prompt "Flake directory > " --value "$FLAKE_DIR")
      [ -z "$flake" ] && { gum log --level error "Flake path required"; exit 1; }

      # Pre‑flight flake check
      if confirm "Run 'nix flake check' before installation?"; then
        spinner "Running flake checks" "nix flake check \"$flake\" --no-build"
      fi

      # Partition via flake
      if confirm "Partition disks for $host using the flake layout? This DESTROYS data."; then
        spinner "Partitioning disks" \
          "sudo disko --yes-wipe-all-disks --mode destroy,format,mount --flake \"$flake#$host\""
      else
        gum log --level warn "Disko partitioning skipped. Ensure disks are ready."
      fi

      # Install
      if confirm "Run nixos-install for $host?"; then
        spinner "Installing NixOS" \
          "sudo nixos-install --no-channel-copy --no-root-password --flake \"$flake#$host\""
      else
        gum log --level warn "nixos-install skipped"
      fi
      ;;

      ############################ Install Doom Emacs #############################
    "Install Doom Emacs")
      section "Install Doom Emacs"
      divider
      if confirm "Install/overwrite Doom Emacs in ~/.config?"; then
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
      section "Copy host SSH key"
      divider
      addr=$(prompt "Remote host/IP > ")
      hname=$(prompt "Destination hostname entry > ")
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

    "Get nixGL")
      section "Get nixGL"
      divider
      if confirm "Install nixGL ( it's not in our flake bc adds impurity )"; then
        spinner "Installing nixGL" \
          "nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update && \
          nix-env -iA nixgl.auto.nixGLDefault"
      else
        gum log --level warn "Not installing nixGL"
      fi
      ;;

    "Get password vault")
      section "Get password vault"
      divider
      PASS_DIR=$(prompt "Clone directory > " --value "$PASSAGE_DIR")
      [ -z "$PASS_DIR" ] && { gum log --level error "Directory path required"; exit 1; }

      if [[ -d "$PASS_DIR/.git" ]]; then
        if confirm "Directory exists. Run git pull instead?"; then
          spinner "Updating vault ..." "git -C \"$PASS_DIR\" pull"
        else
          gum log --level warn "Skipped update"
        fi
      else
        spinner "Cloning vault ..." "git clone \"$P_REPO\" \"$PASS_DIR\""
      fi
      ;;
    "Quit") exit 0 ;;
  esac
done

unset IFS  # restore default word splitting

gum log --level warn "All selected tasks completed. You can reboot now."
