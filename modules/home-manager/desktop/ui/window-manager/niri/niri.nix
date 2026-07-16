# stolen from: github.com/linuxmobile/kaku
{ inputs, ... }:
{
  config.flake.modules.homeManager.niri =
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
