# emacs-daemon: Emacs daemon as the default editor, with the emacsclient
# Hyprland binding. Importing this module enables both the service and the
# default-editor behavior (occhima's current selection).
{
  flake.modules.homeManager.emacs-daemon = {
    services.emacs = {
      enable = true;
      client = {
        enable = true;
        arguments = [ "-c" ];
      };
      defaultEditor = true;
      startWithUserSession = "graphical";
    };

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, E, exec, emacsclient -c"
    ];
  };
}
