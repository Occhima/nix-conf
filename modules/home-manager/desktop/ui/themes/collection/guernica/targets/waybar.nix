{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  # Add custom Waybar CSS styling (without color references)
  programs.waybar.style = lib.mkIf (cfg.enable && cfg.name == "guernica") (
    lib.mkAfter ''
      window#waybar {
        background-color: transparent;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.1;
      }

      button {
        border-radius: 3px;
        background-color: transparent;
      }

      #workspaces button:hover {
        border-color: transparent;
        box-shadow: none;
        text-shadow: none;
        background: none;
        transition: none;
      }

      #workspaces {
        margin-top: 6px;
        border-radius: 3px;
      }

      #workspaces button:hover {
        opacity: 0.8;
      }

      #workspaces button.active {
        opacity: 1;
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
        padding: 0px 5px;
        border-radius: 3px;
      }

      .modules-left > widget:first-child > #workspaces {
        margin-left: 8px;
      }

      .modules-right > widget:last-child {
        padding-right: 0px;
        margin-right: 5px;
      }

      #clock {
        margin-right: 8px;
      }

      #custom-swaylock {
        padding: 0px 5px;
        border-radius: 3px;
        margin-top: 6px;
      }

      #battery.charging, #battery.plugged {
        padding: 0px 5px;
        border-radius: 3px;
      }

      @keyframes blink {
        to {
          padding: 0px 5px;
          border-radius: 3px;
        }
      }

      #battery.critical:not(.charging) {
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        padding: 0px 5px;
        border-radius: 3px;
      }

      label:focus {
        border-radius: 3px;
      }

      #network.disconnected {
        padding: 0px 5px;
        border-radius: 3px;
      }

      #pulseaudio.muted {
        padding: 0px 5px;
        border-radius: 3px;
      }

      #temperature.critical {
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
        border-radius: 3px;
      }

      #idle_inhibitor.activated {
        border-radius: 3px;
      }
    ''
  );
}
