{
  pkgs,
  config,
  lib,
  ...

}:
{

  config = {

    home.packages = [
      pkgs.hyprpicker
    ];

    wayland.windowManager.hyprland = {

      # TODO: add hyprsplit
      plugins = with pkgs.hyprlandPlugins; [
        hyprfocus
        hyprexpo
      ];

      settings = {
        plugins = {
          hyprfocus = {
            enabled = true;
            keyboard_focus_animation = "shrink";
            mouse_focus_animation = "flash";
          };
          hyprexpo = {
            rows = 3;
            columns = 3;
            gap_size = config.wayland.windowManager.hyprland.settings.general.gaps_in;
          };
        };
        bind = [
          # plugins
          "$mainMod, C, exec, ${lib.getExe pkgs.hyprpicker}"
          "$mainMod, TAB, hyprexpo:expo, toggle"
        ];
      };
    };
  };

}
