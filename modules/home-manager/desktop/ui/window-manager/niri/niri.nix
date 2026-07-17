# stolen from: github.com/linuxmobile/kaku
{ inputs, ... }:
{
  occhima.niri.homeManager =
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
