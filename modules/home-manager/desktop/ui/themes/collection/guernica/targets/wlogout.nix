# NOTE: stole from: https://gitlab.com/saibhargav/arch-hypr-mini/-/blob/main/wlogout/style.css?ref_type=heads
{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;

  stylixColors = config.lib.stylix.colors;
in

{

  programs.wlogout = mkIf (cfg.enable && cfg.name == "guernica") {

    layout = [
      {
        label = "lock";
        action = "swaylock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "swaylock -f && systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = with stylixColors; ''
      *
      {
          all: unset;
          background-image: none;
          transition: 400ms cubic-bezier(0.05, 0.7, 0.1, 1);

      }

      window {
          font-family: ${config.stylix.fonts.monospace.name}, monospace;
          font-size: ${toString config.stylix.fonts.sizes.applications}pt;
          background: #${base00};
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          font-size: 30px;
          padding-top: 100px;
          padding-bottom: 100px;
          background-size: 50%;
          border: none;
          color: #${base05};
          text-shadow: none;
          border-radius: 20px 20px 20px 20px;
          background-color: #${base00};
          margin: 1px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
          background-color: #${base01};
      }

    '';

  };

}
