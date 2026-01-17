# XXX: Is this supposed to be here?
# TODO: find a better place for this module
{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  desktopCfg = config.modules.desktop;
in
{

  options.modules.desktop.apps.lutris = {
    enable = mkEnableOption "lutris";
  };

  config = mkIf (desktopCfg.apps.lutris.enable) {

    home.packages = with pkgs; [
      mangohud
      protonplus
      winetricks
      umu-launcher
      bbe
    ];
    programs.lutris = {
      enable = true;
      defaultWinePackage = pkgs.proton-ge-bin;
      steamPackage = osConfig.programs.steam.package;
      protonPackages = [ pkgs.proton-ge-bin ];
      winePackages = with pkgs; [
        wineWow64Packages.full
        wineWowPackages.stagingFull
      ];
      extraPackages = with pkgs; [
        winetricks
        gamescope
        gamemode
        mangohud
        umu-launcher
      ];
    };
  };
}
