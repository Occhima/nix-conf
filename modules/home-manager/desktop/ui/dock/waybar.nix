{ ... }:
{
  config.occhima.waybar-dock.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pavucontrol ];
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };
    };
}
