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
        hyprsplit
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
            columns = 2;
            gap_size = config.wayland.windowManager.hyprland.settings.general.gaps_in;
          };
          hyprsplit = { };
        };
        bind = [
          # plugins
          "$mainMod, C, exec, ${lib.getExe pkgs.hyprpicker}"

          # hyrpexpo
          "$mainMod, TAB, hyprexpo:expo, toggle"

          # hyprsplit
          "$mainMod, 1, split:workspace, 1"
          "$mainMod, 2, split:workspace, 2"
          "$mainMod, 3, split:workspace, 3"
          "$mainMod, 4, split:workspace, 4"
          "$mainMod, 5, split:workspace, 5"
          "$mainMod, 6, split:workspace, 6"

          "$mainMod SHIFT, 1, split:movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, split:movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, split:movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, split:movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, split:movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, split:movetoworkspacesilent, 6"

          "$mainMod, D, split:swapactiveworkspaces, current +1"
          "$mainMod, G, split:grabroguewindows"

        ];
      };
    };
  };

}
