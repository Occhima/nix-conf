{
  flake.modules.homeManager.lutris =
    # XXX: Is this supposed to be here?
    # TODO: find a better place for this module
    {
      pkgs,
      osConfig ? { },
      ...
    }:
    {
      config = {
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
          # Under NixOS reuse the system Steam; standalone falls back to pkgs.
          steamPackage = osConfig.programs.steam.package or pkgs.steam;
          protonPackages = [ pkgs.proton-ge-bin ];
          winePackages = with pkgs; [
            wineWow64Packages.waylandFull
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
    };
}
