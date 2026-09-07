{
  flake.modules.homeManager.waybar-dock =
    { config, pkgs, ... }:
    {
      assertions = [
        {
          assertion = !config.programs.quickshell.enable;
          message = "waybar and quickshell both claim the status bar; enable one";
        }
      ];

      home.packages = [ pkgs.pavucontrol ];
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };
    };
}
