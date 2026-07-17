{ ... }:
{
  flake.modules.homeManager.waybar-dock =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pavucontrol ];
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };
    };
}
