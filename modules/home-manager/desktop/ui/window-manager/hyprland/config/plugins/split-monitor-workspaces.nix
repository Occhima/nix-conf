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
        mkIf
        mkMerge
        range
        ;
      per = 9;
      configType = config.wayland.windowManager.hyprland.configType;

      src = pkgs.fetchFromGitHub {
        owner = "zjeffer";
        repo = "split-monitor-workspaces";
        rev = "f26d624c2638d0661f3e0352a634650bfd08296d";
        hash = "sha256-D0pKfzVlRz8VnLIZVaPtr2d+LHYspICllgIz+oQlw98=";
      };

      smw = call: "function() require(\"split-monitor-workspaces\").${call}() end";
    in
    {
      wayland.windowManager.hyprland = {
        extraConfig = mkIf (configType == "lua") (mkAfter ''
          package.path = package.path .. ";${src}/lua/?.lua"
          require("split-monitor-workspaces").setup({ workspace_count = ${toString per} })
        '');

        settings = mkMerge [
          (hyprlandLib.mkBinds configType (
            map (n: {
              key = toString n;
              dispatcher = "split-workspace";
              argument = toString n;
              lua = smw "workspace(\"${toString n}\")";
            }) (range 1 per)
            ++ map (n: {
              modifiers = [
                "SUPER"
                "SHIFT"
              ];
              key = toString n;
              dispatcher = "split-movetoworkspacesilent";
              argument = toString n;
              lua = smw "move_to_workspace_silent(\"${toString n}\")";
            }) (range 1 per)
            ++ [
              {
                key = "bracketright";
                dispatcher = "split-cycleworkspaces";
                argument = "next";
                lua = smw "cycle_workspaces(\"next\")";
              }
              {
                key = "bracketleft";
                dispatcher = "split-cycleworkspaces";
                argument = "prev";
                lua = smw "cycle_workspaces(\"prev\")";
              }
              {
                key = "mouse_down";
                dispatcher = "split-cycleworkspaces";
                argument = "next";
                lua = smw "cycle_workspaces(\"next\")";
              }
              {
                key = "mouse_up";
                dispatcher = "split-cycleworkspaces";
                argument = "prev";
                lua = smw "cycle_workspaces(\"prev\")";
              }
              {
                modifiers = [
                  "SUPER"
                  "SHIFT"
                ];
                key = "G";
                dispatcher = "split-grabroguewindows";
                lua = smw "grab_rogue_windows()";
              }
              {
                key = "D";
                dispatcher = "split-changemonitor";
                argument = "next";
                lua = "hl.dsp.focus({ monitor = \"+1\" })";
              }
            ]
          ))
        ];
      };
    };
}
