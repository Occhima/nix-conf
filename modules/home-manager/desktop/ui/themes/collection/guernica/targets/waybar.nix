{ lib, config, ... }:

let
  inherit (lib) mkIf mkMerge;

  cfg = config.modules.desktop.ui.themes;
  uiCfg = config.modules.desktop.ui;

  isGuernica = cfg.enable && cfg.name == "guernica";
  isCompact = isGuernica && cfg.variant == "compact";

  usingHyprland = uiCfg.windowManager == "hyprland";
  usingNiri = uiCfg.windowManager == "niri";

  workspacesModule =
    if usingHyprland then
      "hyprland/workspaces"
    else if usingNiri then
      "niri/workspaces"
    else
      "";
  compactWorkspacesModule = "hyprland/workspaces#compact";
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

  defaultVariant = {
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

        #workspaces button.{
            background-color: rgba(150,150,150,0.2);
            border-radius: 3px;
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

  compactVariant = {
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 38;
      spacing = 8;
      margin-top = 6;
      margin-bottom = 0;
      margin-left = 8;
      margin-right = 8;
      fixed-center = true;

      modules-left = [
        "custom/menu"
        "hyprland/window"
        compactWorkspacesModule
        "group/info"
      ];
      modules-center = [ "group/hub" ];
      modules-right = [
        "group/demo"
        "idle_inhibitor"
        "custom/power"
      ];

      ${compactWorkspacesModule} = {
        format = "{icon}";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        on-click = "activate";
        disable-scroll = false;
        active-only = false;
        all-outputs = true;
        sort-by-number = true;
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
        };
        format-icons = {
          "1" = " ";
          "2" = " ";
          "3" = " ";
          "4" = " ";
          "5" = "";
          "6" = " ";
          "7" = "";
          "8" = " ";
          "9" = " ";
          focused = "";
          default = "";
        };
      };

      "custom/separator#blank" = {
        format = "";
        interval = "once";
        tooltip = false;
      };

      "custom/menu" = {
        format = "{}";
        tooltip = true;
        exec = "echo ; echo 󱓟 app launcher";
        interval = 86400;

        # FIXME: use config values
        on-click = "anyrun";
        on-click-right = "wlogout";
      };

      "hyprland/window" = {
        format = "󰣆 {title}";
        max-length = 40;
        separate-outputs = false;
      };

      "group/info" = {
        orientation = "inherit";
        modules = [
          "custom/arrow-right"
          "cpu"
          "memory"
          "temperature"
        ];
      };

      "custom/arrow-right" = {
        format = "󰁙";
        tooltip = false;
      };

      cpu = {
        format = "󰘚 {usage}%";
        tooltip = false;
      };

      memory = {
        interval = 10;
        format = "{percentage}% 󰾆";
        tooltip-format = "{used:0.1f}GB/{total:0.1f}G";
      };

      temperature = {
        interval = 10;
        tooltip = true;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "󰈸" ];
      };

      "group/demo" = {
        orientation = "inherit";
        modules = [
          "group/custom_right"
          "battery"
        ];
      };

      "group/custom_right" = {
        orientation = "horizontal";
        modules = [
          "tray"
          "pulseaudio"
          "mpris"
        ];
      };

      tray = {
        icon-size = 16;
        spacing = 4;
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon}  {volume}%";
        format-muted = "󰝟";
        format-icons = {
          headphone = "";
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
        on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      };

      mpris = {
        interval = 10;
        format = "{status_icon} {artist} - {title}";
        format-paused = "󰏦";
        status-icons = {
          playing = "";
          paused = "";
        };
        max-length = 30;
        on-click-middle = "playerctl play-pause";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = "󱘖 {capacity}%";
        format-icons = [
          "󰂎"
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

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = " ";
          deactivated = " ";
        };
      };

      "group/hub" = {
        orientation = "inherit";
        modules = [
          "group/utils"
          "clock"
        ];
      };

      "group/utils" = {
        orientation = "inherit";
        modules = [
          "custom/arrow-left"
          "custom/notifications"
        ];
      };

      "custom/arrow-left" = {
        format = "󰁒";
        tooltip = false;
      };

      "custom/notifications" = {
        format = "";
        tooltip = false;
      };

      clock = {
        interval = 1;
        format = "{:%I:%M %p}";
        format-alt = " {:%Y-%m-%d}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      "custom/power" = {
        format = "⏻";
        exec = "echo ; echo 󰟡 power";
        interval = 86400;
        tooltip = true;
        on-click = "wlogout";
        on-click-right = "hyprlock";
      };
    };

    style = ''
      * {
        all: unset;
        font-family: ${config.stylix.fonts.monospace.name};
        font-size: 14px;
        font-weight: bold;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.6);
        border-radius: 5px;
        padding: 4px 12px;
      }

      tooltip {
        background: rgba(0, 0, 0, 0.8);
        border-radius: 10px;
        border: 2px solid rgba(255, 255, 255, 0.08);
      }

      #workspaces {
        margin: 4px;
        background: rgba(255, 255, 255, 0.08);
        border-radius: 6px;
      }

      #workspaces button {
        padding: 0 6px;
        color: #d8dee9;
      }

      #workspaces button.active {
        color: #ffffff;
        background: rgba(255, 255, 255, 0.05);
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.08);
      }

      #hyprland-window,
      #clock,
      #battery,
      #pulseaudio,
      #tray,
      #idle_inhibitor,
      #mpris,
      #cpu,
      #memory,
      #temperature,
      #custom-power,
      #custom-menu,
      #custom-arrow-right,
      #custom-arrow-left,
      #custom-notifications {
        padding: 4px 8px;
        margin: 4px 2px;
        background: rgba(0, 0, 0, 0.35);
        border-radius: 8px;
      }

      #tray {
        background: rgba(0, 0, 0, 0.45);
      }

      #custom-power,
      #custom-menu {
        background: rgba(0, 0, 0, 0.55);
      }

      #mpris {
        min-width: 200px;
      }
    '';
  };

  activeVariant = if isCompact && usingHyprland then compactVariant else defaultVariant;
in
{
  stylix.targets.waybar = mkIf isGuernica {
    enable = false;
    addCss = false;
    enableCenterBackColors = false;
    enableLeftBackColors = false;
    enableRightBackColors = false;
  };

  programs.waybar = mkIf isGuernica activeVariant;
}
