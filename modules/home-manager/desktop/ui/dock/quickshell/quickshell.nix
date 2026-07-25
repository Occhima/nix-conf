{
  flake.modules.nixos.quickshell-support = {
    services.upower.enable = true;
  };

  flake.modules.homeManager.quickshell-dock =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
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
          if config.programs.hyprlock.enable then
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

      qs-network-details = pkgs.writeShellApplication {
        name = "qs-network-details";
        runtimeInputs = with pkgs; [
          iproute2
          jq
          coreutils
          gawk
          librespeed-cli
        ];
        text = ''
          export LC_ALL=C

          active_interface=""
          ipv4=""
          gateway=""
          down_mbps="0"
          up_mbps="0"

          route_line="$(ip route get 1.1.1.1 2>/dev/null | head -n1 || true)"
          if [ -n "$route_line" ]; then
            active_interface="$(printf '%s\n' "$route_line" | awk '{for (i=1; i<=NF; i++) if ($i == "dev") {print $(i+1); exit}}')"
          fi

          if [ -n "$active_interface" ]; then
            ipv4="$(ip -4 -o addr show dev "$active_interface" 2>/dev/null | awk 'NR==1 {print $4}' | cut -d/ -f1)"
            gateway="$(ip route show default dev "$active_interface" 2>/dev/null | awk 'NR==1 {for (i=1; i<=NF; i++) if ($i == "via") {print $(i+1); exit}}')"
          fi

          if speed_json="$(librespeed-cli --json 2>/dev/null)"; then
            down_mbps="$(printf '%s' "$speed_json" | jq -r '(.download // .downloadSpeed // 0 | tostring)' 2>/dev/null || printf '0')"
            up_mbps="$(printf '%s' "$speed_json" | jq -r '(.upload // .uploadSpeed // 0 | tostring)' 2>/dev/null || printf '0')"
          fi

          printf 'ACTIVE_INTERFACE=%s\n' "$active_interface"
          printf 'IPV4=%s\n' "$ipv4"
          printf 'GATEWAY=%s\n' "$gateway"
          printf 'DOWN_MBPS=%s\n' "$down_mbps"
          printf 'UP_MBPS=%s\n' "$up_mbps"
        '';
      };
    in
    {
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
        qs-network-details
      ];

      home.sessionVariables.QS_NOTIFICATION_BACKEND = config.modules.desktop.notifications.backend;

      programs.quickshell = {
        enable = true;
        package = wrappedPkg;
        activeConfig = "base";
        configs.base = ./config;
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };

      systemd.user.services.quickshell.Service = {
        Environment = [
          "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/run/wrappers/bin"
          "QS_NOTIFICATION_BACKEND=${config.modules.desktop.notifications.backend}"
        ];
        ExecStartPre = lib.mkIf (
          config.modules.desktop.notifications.backend == "quickshell"
        ) "-${pkgs.procps}/bin/pkill -x mako";
      };
    };
}
