# stolen from: github.com/linuxmobile/kaku
{ ... }:
{
  config.flake.modules.homeManager.niri =
    {
      inputs,
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
