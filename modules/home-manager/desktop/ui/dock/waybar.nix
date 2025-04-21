{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;
in
{
  config = mkIf (cfg.dock == "waybar") {
    home.packages = [ pkgs.pavucontrol ];
    programs.waybar = {
      enable = true;
      systemd.enable = true;

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
          "network"
          "pulseaudio"
          "cpu"
          "memory"
          "battery"
          "tray"
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

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory = {
          format = "{}% ";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = "󰝟 {icon}";
          format-muted = "󰝟";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
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
    };
  };
}
