{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  # The original Guernica bar remains available as an explicit variant. It is
  # no longer smuggled into the generic Quickshell runtime.
  flake.modules.homeManager.themes-guernica-quickshell-base =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.lib.stylix) colors;

      qs-network-details = pkgs.writeShellApplication {
        name = "qs-network-details";
        runtimeInputs = with pkgs; [
          coreutils
          gawk
          iproute2
          jq
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

      themedConfig = pkgs.runCommand "quickshell-guernica-base" { } ''
        mkdir -p "$out"
        # This source root is directly launchable. Materialize its links to
        # the neutral shared toolkit before applying the active palette.
        cp -RL ${./.}/configs/base/. "$out/"
        chmod -R u+w "$out"
        substituteInPlace "$out/data/Settings.qml" \
          --replace-fail '"#141818"' '"#${colors.base00}"' \
          --replace-fail '"#1e2424"' '"#${colors.base01}"' \
          --replace-fail '"#3c4848"' '"#${colors.base02}"' \
          --replace-fail '"#f8f8f8"' '"#${colors.base05}"' \
          --replace-fail '"#909090"' '"#${colors.base03}"' \
          --replace-fail '"#40c4ff"' '"#${colors.base0D}"' \
          --replace-fail '"#ffb000"' '"#${colors.base08}"' \
          --replace-fail '"#a0ff20"' '"#${colors.base0A}"' \
          --replace-fail '"#ff0060"' '"#${colors.base0E}"' \
          --replace-fail '"#c080ff"' '"#${colors.base0C}"' \
          --replace-fail '"#6080ff"' '"#${colors.base09}"' \
          --replace-fail '"#ffe080"' '"#${colors.base0B}"' \
          --replace-fail \
            'readonly property color notificationSurface: bgColorTranslucent' \
            'readonly property color notificationSurface: bgLightTranslucent'
      '';
    in
    {
      imports = [ hm.themes-guernica-quickshell-common ];

      home.packages = [ qs-network-details ];

      programs.quickshell = {
        activeConfig = "guernica-base";
        configs.guernica-base = themedConfig;
      };
    };
}
