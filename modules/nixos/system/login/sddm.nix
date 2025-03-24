{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.system.login;
in
{
  config = mkIf (cfg.enable && cfg.manager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = config.modules.system.display.type == "wayland";
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
