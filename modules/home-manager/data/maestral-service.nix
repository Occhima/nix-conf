# Maestral systemd user service. Importing this module activates the service;
# the plain `maestral` module only ships the binaries.
{
  flake.modules.homeManager.maestral-service =
    { pkgs, ... }:
    {
      systemd.user.services.maestral = {
        Unit = rec {
          Description = "Maestral - a open-source Dropbox client";
          After = [ "graphical-session.target" ];
          Requires = After;
        };

        Service = {
          Type = "notify";
          ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
          ExecStop = "${pkgs.maestral}/bin/maestral stop";
          Nice = 10;
          Restart = "on-failure";
          RestartSec = "5s";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
