# stolen from: github.com/linuxmobile/kaku
{ inputs, ... }:
{
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.niri =
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
