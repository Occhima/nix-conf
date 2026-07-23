# split-monitor-workspaces: awesome-like per-monitor workspaces for Hyprland
# (zjeffer fork). Importing this module enables the plugin, its settings and
# its binds.
{
  flake.modules.homeManager.hyprland =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) range;
      per = 9;

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
        ]
        ++ (pkgs.hyprland.buildInputs or [ ]);

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
      wayland.windowManager.hyprland = {
        plugins = [ splitMonitorWorkspaces ];

        settings = {
          plugin.split-monitor-workspaces = {
            count = per;
            enable_hy3 = true;
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
