{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;
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
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 5;
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 2;
      margin-right = 2;

      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "tray"
        "network"
        "pulseaudio"
        "cpu"
        "memory"
        "disk"
        "battery"

      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        active-only = false;
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          "urgent" = "  ";
          "active" = "  ";
          "default" = " 󰧞 ";
        };
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
          "6" = [ ];
          "7" = [ ];
          "8" = [ ];
          "9" = [ ];
          "10" = [ ];
        };
      };

      clock = {
        format = "   {:%H:%Mj ";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        # format-icons = [ "" ]; # Font Awesome clock icon
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
        format = "{icon} {}%";
        format-icons = [ "" ]; # Font Awesome memory icon
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon}  {volume}%";
        format-bluetooth-muted = "󰝟 {icon}";
        format-muted = "󰝟";
        format-source = "{volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = ""; # Headphone icon
          hands-free = ""; # Hands-free icon
          headset = ""; # Headset icon
          phone = ""; # Phone icon
          portable = ""; # Portable device icon
          car = ""; # Car icon
          default = [
            ""
            ""
            ""
          ]; # Volume level icons: muted, low, high
        };
        on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
        on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      };

      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipsddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{time} {icon}";
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
    };

    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: Iosevka;
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
