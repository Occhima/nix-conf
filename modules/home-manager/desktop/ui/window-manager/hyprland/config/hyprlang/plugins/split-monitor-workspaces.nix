{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf range elem;
  hyprCfg = config.modules.desktop.ui.windowManagerOpts.hyprland;
  per = 9;
  hy3On = elem "hy3" hyprCfg.plugins.enabledPlugins;
  enabled =
    hyprCfg.enable
    && hyprCfg.plugins.enable
    && elem "split-monitor-workspaces" hyprCfg.plugins.enabledPlugins;

  splitMonitorWorkspaces = pkgs.hyprland.stdenv.mkDerivation {
    pname = "split-monitor-workspaces";
    version = "unstable-2026-05-15";

    src = pkgs.fetchFromGitHub {
      owner = "zjeffer";
      repo = "split-monitor-workspaces";
      rev = "7fa10d87b486401549267edb73f6145dd524d6f0";
      hash = "sha256-fqWPifkCkwkTPrGosPN+wLQcy8AJMD3UIzRcLUN/3rA=";
    };

    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
    ];

    buildInputs = [
      pkgs.hyprland.dev
      pkgs.pango
      pkgs.cairo
    ] ++ (pkgs.hyprland.buildInputs or [ ]);

    BUILT_WITH_NOXWAYLAND = false;

    meta = with lib; {
      description = "Awesome-like per-monitor workspaces for Hyprland (zjeffer fork)";
      homepage = "https://github.com/zjeffer/split-monitor-workspaces";
      license = licenses.bsd3;
      platforms = platforms.linux;
    };
  };
in
{
  config = mkIf enabled {
    wayland.windowManager.hyprland = {
      plugins = [ splitMonitorWorkspaces ];

      settings = {
        plugin.split-monitor-workspaces = {
          count = per;
          enable_hy3 = hy3On;
        };

        bind =
          map (n: "$mainMod, ${toString n}, split-workspace, ${toString n}") (range 1 per)
          ++ map (n: "$mainMod SHIFT, ${toString n}, split-movetoworkspacesilent, ${toString n}") (
            range 1 per
          )
          ++ [
            "$mainMod, bracketright, split-cycleworkspaces, next"
            "$mainMod, bracketleft, split-cycleworkspaces, prev"
            "$mainMod, G, split-grabroguewindows"
            "$mainMod, D, split-changemonitor, next"
          ];
      };
    };
  };
}
