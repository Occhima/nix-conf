{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  # Guernica shell integration shared by its named Quickshell variants. It is
  # intentionally separate from the generic Quickshell runtime.
  flake.modules.homeManager.themes-guernica-quickshell-common =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      notificationBackend = config.modules.desktop.notifications.backend;

      qs-logout = pkgs.writeShellApplication {
        name = "qs-logout";
        runtimeInputs = [ pkgs.systemd ];
        text =
          if config.programs.wlogout.enable or false then
            "exec ${pkgs.wlogout}/bin/wlogout"
          else
            "loginctl terminate-session";
      };

      qs-lock = pkgs.writeShellApplication {
        name = "qs-lock";
        runtimeInputs = [ pkgs.systemd ];
        text =
          if config.programs.hyprlock.enable or false then
            "exec ${pkgs.hyprlock}/bin/hyprlock"
          else
            "loginctl lock-session";
      };

      qs-network-settings = pkgs.writeShellApplication {
        name = "qs-network-settings";
        text = "exec ${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      qs-network-status = pkgs.writeShellApplication {
        name = "qs-network-status";
        runtimeInputs = with pkgs; [
          coreutils
          gawk
          networkmanager
        ];
        text = ''
          export LC_ALL=C

          wifi_enabled="$(nmcli radio wifi)"
          wifi_device="$(nmcli -t -f DEVICE,TYPE,STATE device status | awk -F: '$2 == "wifi" && $3 == "connected" { print $1; exit }')"
          ethernet_device="$(nmcli -t -f DEVICE,TYPE,STATE device status | awk -F: '$2 == "ethernet" && $3 == "connected" { print $1; exit }')"

          printf 'WIFI_ENABLED=%s\n' "$wifi_enabled"
          if [ -n "$wifi_device" ]; then
            connection="$(nmcli -g GENERAL.CONNECTION device show "$wifi_device" | head -n1)"
            ssid="$(nmcli --escape no -g 802-11-wireless.ssid connection show "$connection" 2>/dev/null | head -n1 || true)"
            signal="$(nmcli -t -f IN-USE,SIGNAL device wifi list ifname "$wifi_device" --rescan no | awk -F: '$1 == "*" { print $2; exit }')"
            if [ -z "$ssid" ]; then
              ssid="$connection"
            fi
            if [ -z "$signal" ]; then
              signal=0
            fi

            printf 'WIFI_CONNECTED=yes\n'
            printf 'WIFI_SSID=%s\n' "$ssid"
            printf 'WIFI_SIGNAL=%s\n' "$signal"
          else
            printf 'WIFI_CONNECTED=no\n'
          fi

          if [ -n "$ethernet_device" ]; then
            printf 'ETH_CONNECTED=yes\n'
          else
            printf 'ETH_CONNECTED=no\n'
          fi
        '';
      };
    in
    {
      imports = [
        hm.quickshell-runtime
      ];

      home.packages = [
        pkgs.blueman
        pkgs.curl
        pkgs.lm_sensors
        pkgs.networkmanager
        pkgs.procps
        qs-logout
        qs-lock
        qs-network-settings
        qs-network-status
      ];

      home.sessionVariables.QS_NOTIFICATION_BACKEND = notificationBackend;

      systemd.user.services.quickshell.Service = {
        Environment = [
          "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/run/wrappers/bin"
          "QS_NOTIFICATION_BACKEND=${notificationBackend}"
        ];
        ExecStartPre = lib.mkIf (notificationBackend == "quickshell") "-${pkgs.procps}/bin/pkill -x mako";
      };
    };
}
