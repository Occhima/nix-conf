{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.login;
in
{
  config = mkIf (cfg.enable && cfg.manager == "sddm") {
    services.xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = config.modules.display.wayland.enable or false;
      enableHidpi = true;

      settings = {
        X11 = {
          UserAuthFile = ".local/share/sddm/Xauthority";
        };
      };
    };

    # Auto login if enabled
    services.xserver.displayManager.autoLogin = mkIf cfg.autoLogin {
      enable = true;
      user = config.users.users.mainUser.name or "root";
    };
  };
}
