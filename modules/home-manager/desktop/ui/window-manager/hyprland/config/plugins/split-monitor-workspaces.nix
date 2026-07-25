{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkAfter
        mkMerge
        range
        ;
      per = 9;
      configType = config.wayland.windowManager.hyprland.configType;

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
        plugins = mkAfter [ splitMonitorWorkspaces ];

        settings = mkMerge [
          (hyprlandLib.mkPluginConfig configType {
            luaName = "split_monitor_workspaces";
            legacyName = "split-monitor-workspaces";
            settings = {
              count = per;
              enable_hy3 = true;
            };
          })
          (hyprlandLib.mkBinds configType (
            map (n: {
              key = toString n;
              dispatcher = "split-workspace";
              argument = toString n;
              lua = "function() return hl.plugin.split_monitor_workspaces.workspace(${toString n}) end";
            }) (range 1 per)
            ++ map (n: {
              modifiers = [
                "SUPER"
                "SHIFT"
              ];
              key = toString n;
              dispatcher = "split-movetoworkspacesilent";
              argument = toString n;
              lua = "function() return hl.plugin.split_monitor_workspaces.move_to_workspace_silent(${toString n}) end";
            }) (range 1 per)
            ++ [
              {
                key = "bracketright";
                dispatcher = "split-cycleworkspaces";
                argument = "next";
                lua = "function() return hl.plugin.split_monitor_workspaces.cycle_workspaces(\"next\") end";
              }
              {
                key = "bracketleft";
                dispatcher = "split-cycleworkspaces";
                argument = "prev";
                lua = "function() return hl.plugin.split_monitor_workspaces.cycle_workspaces(\"prev\") end";
              }
              {
                key = "mouse_down";
                dispatcher = "split-cycleworkspaces";
                argument = "next";
                lua = "function() return hl.plugin.split_monitor_workspaces.cycle_workspaces(\"next\") end";
              }
              {
                key = "mouse_up";
                dispatcher = "split-cycleworkspaces";
                argument = "prev";
                lua = "function() return hl.plugin.split_monitor_workspaces.cycle_workspaces(\"prev\") end";
              }
              {
                modifiers = [
                  "SUPER"
                  "SHIFT"
                ];
                key = "G";
                dispatcher = "split-grabroguewindows";
                lua = "function() return hl.plugin.split_monitor_workspaces.grab_rogue_windows() end";
              }
              {
                key = "D";
                dispatcher = "split-changemonitor";
                argument = "next";
                lua = "function() return hl.plugin.split_monitor_workspaces.change_monitor(\"next\") end";
              }
            ]
          ))
        ];
      };
    };
}
