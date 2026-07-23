{
  flake.modules.nixos.login-greetd =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) concatStringsSep;
      accountsCfg = config.modules.accounts;

      sessionData = config.services.displayManager.sessionData.desktops;
      sessionPath = concatStringsSep ":" [
        "${sessionData}/share/xsessions"
        "${sessionData}/share/wayland-sessions"
      ];

      tuigreetCommand =
        let
          command = [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--time"
            "--remember"
            "--remember-user-session"
            "--asterisks"
            "--sessions '${sessionPath}'"
          ];
        in
        concatStringsSep " " command;
    in
    {
      config = {
        services.greetd = {
          enable = true;

          settings = {
            default_session = {
              user = accountsCfg.mainUser or "greeter";
              command = tuigreetCommand;
            };
          };
        };
      };
    };
}
