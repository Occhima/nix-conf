{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;

  wrappedPkg = pkgs.symlinkJoin {
    name = "quickshell-wrapped";
    paths = with pkgs; [
      quickshell
      qt6.qtimageformats
      adwaita-icon-theme
      kdePackages.kirigami
    ];
    meta.mainProgram = pkgs.quickshell.meta.mainProgram;
  };

  qs-logout = pkgs.writeShellScriptBin "qs-logout" ''
    ${
      if config.modules.desktop.apps.wlogout.enable then
        "${pkgs.wlogout}/bin/wlogout"
      else
        "loginctl terminate-session"
    }
  '';

  qs-lock = pkgs.writeShellScriptBin "qs-lock" ''
    ${if cfg.locker == "hyprlock" then "${pkgs.hyprlock}/bin/hyprlock" else "loginctl lock-session"}
  '';

  qs-network-settings = pkgs.writeShellScriptBin "qs-network-settings" ''
    exec ${pkgs.networkmanagerapplet}/bin/nm-connection-editor
  '';

  qs-network-details = pkgs.writeShellApplication {
    name = "qs-network-details";
    runtimeInputs = with pkgs; [
      iproute2
      jq
      coreutils
      librespeed-cli
    ];
    text = ''
      active_interface=""
      ipv4=""
      gateway=""
      down_kbps="0"
      up_kbps="0"

      route_line="$(ip route get 1.1.1.1 2>/dev/null | head -n1 || true)"
      if [ -n "$route_line" ]; then
        active_interface="$(printf '%s\n' "$route_line" | awk '{for (i=1; i<=NF; i++) if ($i == "dev") {print $(i+1); exit}}')"
      fi

      if [ -n "$active_interface" ]; then
        ipv4="$(ip -4 -o addr show dev "$active_interface" 2>/dev/null | awk 'NR==1 {print $4}' | cut -d/ -f1)"
        gateway="$(ip route show default dev "$active_interface" 2>/dev/null | awk 'NR==1 {for (i=1; i<=NF; i++) if ($i == "via") {print $(i+1); exit}}')"
      fi

      if speed_json="$(librespeed-cli --json 2>/dev/null)"; then
        down_kbps="$(printf '%s' "$speed_json" | jq -r '(((.download // .downloadSpeed // 0) / 8) / 1024) | floor | tostring' 2>/dev/null || printf '0')"
        up_kbps="$(printf '%s' "$speed_json" | jq -r '(((.upload // .uploadSpeed // 0) / 8) / 1024) | floor | tostring' 2>/dev/null || printf '0')"
      fi

      printf 'ACTIVE_INTERFACE=%s\n' "$active_interface"
      printf 'IPV4=%s\n' "$ipv4"
      printf 'GATEWAY=%s\n' "$gateway"
      printf 'DOWN_KBPS=%s\n' "$down_kbps"
      printf 'UP_KBPS=%s\n' "$up_kbps"
    '';
  };
in
{
  config = mkIf (cfg.dock == "quickshell") {
    home.packages = [
      pkgs.librespeed-cli
      qs-logout
      qs-lock
      qs-network-settings
      qs-network-details
    ];

    programs.quickshell = {
      enable = true;
      package = wrappedPkg;
      activeConfig = "base";
      configs = {
        base = ./config;
      };
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };
  };
}
