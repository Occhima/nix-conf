{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf range elem;
  hyprCfg = config.modules.desktop.ui.windowManagerOpts.hyprland;
  per = hyprCfg.workspaces.perMonitor;
  enabled =
    hyprCfg.enable && hyprCfg.plugins.enable && elem "hyprsplit" hyprCfg.plugins.enabledPlugins;
in
{
  config = mkIf enabled {
    wayland.windowManager.hyprland = {
      plugins = with pkgs.hyprlandPlugins; [
        (hyprsplit.overrideAttrs (_p: rec {
          # TODO: drop when nixpkgs catches up
          version = "0.54.3";
          src = pkgs.fetchFromGitHub {
            owner = "shezdy";
            repo = "hyprsplit";
            tag = "v${version}";
            hash = "sha256-0/b9n3NvXiA2NGz2Bt/h8TLyBc+twJiHriHyI8JovdI=";
          };
        }))
      ];

      settings = {
        plugins.hyprsplit = {
          num_workspaces = per;
          persistent_workspaces = true;
        };

        bind =
          map (n: "$mainMod, ${toString n}, split:workspace, ${toString n}") (range 1 per)
          ++ map (n: "$mainMod SHIFT, ${toString n}, split:movetoworkspacesilent, ${toString n}") (
            range 1 per
          )
          ++ [
            "$mainMod, D, split:swapactiveworkspaces, current +1"
            "$mainMod, G, split:grabroguewindows"
          ];
      };
    };
  };
}
