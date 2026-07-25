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
        version = "unstable-2026-07-25";

        src = pkgs.fetchFromGitHub {
          owner = "zjeffer";
          repo = "split-monitor-workspaces";
          rev = "c8a03d993f71a3ae73179ce354e7a54859055f02";
          hash = "sha256-XVm8Bi8XasjMP2VOisrPAuJvrB6+rQZW+/TL9kr2Ogs=";
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
