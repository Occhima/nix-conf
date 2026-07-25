{
  flake.modules.homeManager.wlogout =
    # XXX: Is this supposed to be here?
    # TODO: find a better place for this module
    { ... }: {
      config = {
        programs.wlogout = {
          enable = true;
        };

        wayland.windowManager.hyprland.settings.bind = [
          "$mainMod, W, exec, wlogout"
        ];
      };
    };
}
