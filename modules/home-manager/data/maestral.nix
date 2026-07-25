{
  flake.modules.homeManager.maestral = { pkgs, ... }: {
    home.packages = [
      pkgs.maestral
      pkgs.maestral-gui
    ];
  };
}
