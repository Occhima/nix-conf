{
  flake.modules.homeManager.hyprland =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkForce;

      hy3 = pkgs.hyprlandPlugins.hy3.overrideAttrs (_: {
        version = "0.56.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "outfoxxed";
          repo = "hy3";
          rev = "42b7ed8fd9aefd3f36e5f617afd5071245c67853";
          hash = "sha256-iK0vERuy5aXisDXm/bzcJP0dgaIot5MLPoVG62DjqO4=";

        };
      });
    in
    {
      wayland.windowManager.hyprland = {
        plugins = [ hy3 ];

        settings = {
          general.layout = mkForce "hy3";

          bind = [
            # Tab groups
            "$mainMod, T, hy3:makegroup, tab"
            "$mainMod, H, hy3:makegroup, h"
            "$mainMod, U, hy3:makegroup, v"
            "$mainMod, A, hy3:changefocus, raise"
            "$mainMod SHIFT, A, hy3:changefocus, lower"

            # Tree-aware focus (base movefocus binds are gated off in keybindings.nix)
            "$mainMod, left, hy3:movefocus, l"
            "$mainMod, right, hy3:movefocus, r"
            "$mainMod, up, hy3:movefocus, u"
            "$mainMod, down, hy3:movefocus, d"

            # Move window in tree
            "$mainMod CTRL, left, hy3:movewindow, l"
            "$mainMod CTRL, right, hy3:movewindow, r"
            "$mainMod CTRL, up, hy3:movewindow, u"
            "$mainMod CTRL, down, hy3:movewindow, d"
          ];
        };
      };
    };
}
