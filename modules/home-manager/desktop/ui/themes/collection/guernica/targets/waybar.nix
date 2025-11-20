{ lib, config, ... }:

let
  inherit (lib) mkIf mkMerge;

  cfg = config.modules.desktop.ui.themes;
  uiCfg = config.modules.desktop.ui;

  usingHyprland = uiCfg.windowManager == "hyprland";
  usingNiri = uiCfg.windowManager == "niri";

  workspacesModule =
    if usingHyprland then
      "hyprland/workspaces"
    else if usingNiri then
      "niri/workspaces"
    else
      "";
  perWMWorkspaceSettings = mkMerge [
    (mkIf usingHyprland {
      ${workspacesModule} = {
        disable-scroll = true;
        all-outputs = false;
        active-only = false;
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          "11" = "1";
          "12" = "2";
          "13" = "3";
          "14" = "4";
          "15" = "5";
          "16" = "6";
          "17" = "7";
          "18" = "8";
          "19" = "9";
          "20" = "10";
          "21" = "1";
          "22" = "2";
          "23" = "3";
          "24" = "4";
          "25" = "5";
          "26" = "6";
          "27" = "7";
          "28" = "8";
          "29" = "9";
          "30" = "10";
        };
      };
    })
    (mkIf usingNiri {
      ${workspacesModule} = {
        format = "{name}";
        all-outputs = false;
        active-only = false;
      };
    })
  ];
in
{
  stylix.targets.waybar = mkIf (cfg.enable && cfg.name == "guernica") {
    enable = false;
    addCss = false;
    enableCenterBackColors = false;
    enableLeftBackColors = false;
    enableRightBackColors = false;
  };

  programs.waybar = mkIf (cfg.enable && cfg.name == "guernica") {
    settings.mainBar = mkMerge [
      {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 5;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 2;
        margin-right = 2;

        # 3) Use the chosen module name on the left.
        modules-left = [ workspacesModule ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "cpu"
          "memory"
          "disk"
          "battery"
          "custom/power"
        ];

        "custom/power" = {
          format = " 󰐥 ";
          tooltip = true;
          tooltip-format = "Open power menu";
          on-click = "wlogout";
        };

        clock = {
          format = "   {:%H:%M} ";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "{icon} {usage}%";
          tooltip = false;
          format-icons = [ "󰻠" ];
        };

        disk = {
          path = "/";
          format = " {percentage_used}%";
          unit = "GB";
        };

        memory = {
          format = "{icon} {percentage}%";
          format-icons = [ "󰍛" ];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-bluetooth-muted = "󰝟 {icon}";
          format-muted = "󰝟";
          format-source = "{volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
        };

        network = {
          format-wifi = "   {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "{capacity}%";
          format-plugged = "{capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
      }

      # 4) Per-WM workspace block lands under the right key here.
      perWMWorkspaceSettings
    ];

    style = ''
      * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: ${config.stylix.fonts.monospace.name};
            font-size: 13px;
            min-height: 0;
        }

        window#waybar {
            background-color: rgba(255, 255, 255, 0.0);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
        }

        window#waybar.hidden {
            opacity: 0.1;
        }

        button {
            /* Use box-shadow instead of border so the text isn't offset */
            /* box-shadow: inset 0 -3px transparent; */
            /* Avoid rounded borders under each button name */
            border-radius: 3px;
            background-color: transparent;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
            border-color: rgba(0,0,0,0);
            box-shadow: none; /* Remove predefined box-shadow */
            text-shadow: none; /* Remove predefined text-shadow */
            background: none; /* Remove predefined background color (white) */
            transition: none; /* Disable predefined animations */
        }
        #workspaces {
            margin-top: 6px;
            background-color: rgba(0,0,0,0.6);
            border-radius: 3px;
        }

        #workspaces button {
            color: #ffffff;
        }

        #workspaces button:hover {
            background-color: rgba(150,150,150, 0.15);
        }

        #workspaces button.active {
            background-color: rgba(150,150,150,0.2);
        }

        #workspaces button.urgent {
            background-color: #eb4d4b;
        }

        #clock,
        #battery,
        #cpu,
        #custom-power,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #tray,
        #mode,
        #idle_inhibitor,

        #window {
            margin-top: 6px;
                background-color: rgba(0,0,0,0.6);
            padding: 0px 5px;
            border-radius: 3px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
            margin-left: 8px;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child {
            padding-right: 0px;
            margin-right: 5px;
        }

        #clock {
            margin-right: 8px;
        }

        #custom-swaylock {
            background-color: rgba(0,0,0,0.6);
            padding: 0px 5px;
            border-radius: 3px;
            margin-top: 6px;
        }

        #battery.charging, #battery.plugged {
            background-color: rgba(0,0,0,0.6);
            padding: 0px 5px;
            border-radius: 3px;
        }

        @keyframes blink {
            to {
            background-color: rgba(0,0,0,0.6);
            color: #000000;
            padding: 0px 5px;
            border-radius: 3px;
            }
        }

        #battery.critical:not(.charging) {
            background-color: rgba(0,0,0,0.6);
            color: #ffffff;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
            padding: 0px 5px;
            border-radius: 3px;
        }

        label:focus {
            background-color: rgba(0,0,0,0.6);
        }

        #network.disconnected {
            background-color: rgba(255,0,0,0.6);
            padding: 0px 5px;
            border-radius: 3px;
        }

        #pulseaudio.muted {
            background-color: rgba(0,0,0,0.6);
            padding: 0px 5px;
            border-radius: 3px;
        }

        #temperature.critical {
            background-color: rgba(255,0,0,0.6);
            padding: 0px 5px;
            border-radius: 3px;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
            padding: 0px 5px;
            border-radius: 3px;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: rgba(0,0,0,0.6);
            border-radius: 3px;
        }

        #idle_inhibitor.activated {
            background-color: rgba(0,0,0,0.9);
            border-radius: 3px;
        }
    '';
  };
}
