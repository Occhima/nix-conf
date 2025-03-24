{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.system.login;
  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
in
{
  config = mkIf (cfg.enable && cfg.manager == "greetd") {
    services.greetd = {
      enable = true;
      vt = 2;
      restart = !cfg.autoLogin;

      settings = {
        default_session = {
          user = "greeter";
          command = concatStringsSep " " [
            "${pkgs.greetd.tuigreet}/bin/tuigreet"
            "--time"
            "--remember"
            "--remember-user-session"
            "--asterisks"
            "--sessions '${sessionPath}'"
          ];
        };

        initial_session = mkIf cfg.autoLogin {
          user = config.users.users.mainUser.name or "root";
          command = "${config.modules.display.wayland.enable}";
        };
      };
    };
  };
}
