{
  flake.modules.homeManager.clipboard =
    { config, lib, ... }:
    {
      config = {
        services.clipcat = {
          enable = true;
          enableSystemdUnit = true;
        };

        # ponytail: check rofi program instead of old selector enum
        wayland.windowManager.hyprland.settings.bind = lib.optional (config.programs.rofi.enable or false) [
          "$mainMod, X, exec, clipcat-menu --rofi-menu-length 10"
        ];
      };
    };
}
