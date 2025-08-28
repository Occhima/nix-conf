{
  pkgs,
  ...

}:
{

  config = {

    home.packages = [
      pkgs.hyprpicker
    ];

    wayland.windowManager.hyprland = {

      plugins = [
        pkgs.hyprlandPlugins.hyprfocus
        pkgs.hyprlandPlugins.hyprspace
      ];

      settings = {
        plugins = {
          hyprfocus = {
            mode = "fade";
          };
        };
        overview = {
          # gapsOut = 8;
          # panelHeight = 150;
          showNewWorkspace = true;
          exitOnClick = true;
          exitOnSwitch = true;
          drawActiveWorkspace = true;
          autoDrag = false;
        };
      };
    };
  };

}
