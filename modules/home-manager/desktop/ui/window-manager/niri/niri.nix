{ inputs, ... }:
{
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.niri = { pkgs, ... }: {
    imports = [ inputs.niri.homeModules.config ];

    programs.niri = {
      package = pkgs.niri;
      settings = {
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
      };
    };
  };
}
