# stolen from: github.com/linuxmobile/kaku
{ inputs, ... }:
{
  config.occhima.niri.homeManager =
    {
      pkgs,
      ...
    }:
    {
      imports = [ inputs.niri.homeModules.niri ];
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
    };
}
