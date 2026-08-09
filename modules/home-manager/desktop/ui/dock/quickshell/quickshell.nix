{
  flake.modules.nixos.quickshell-support = {
    services.upower.enable = true;
  };

  # Runtime only. Shell sources, styling, helper programs, and bindings are
  # composed by named theme targets (for example, Guernica's variants).
  flake.modules.homeManager.quickshell-runtime =
    { pkgs, ... }:
    let
      wrappedPkg = pkgs.symlinkJoin {
        name = "quickshell-wrapped";
        paths = with pkgs; [
          quickshell
          qt6.qtimageformats
          adwaita-icon-theme
          kdePackages.kirigami
        ];
        meta.mainProgram = pkgs.quickshell.meta.mainProgram;
      };
    in
    {
      programs.quickshell = {
        enable = true;
        package = wrappedPkg;
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };
    };
}
