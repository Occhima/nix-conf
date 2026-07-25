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
        mkBefore
        mkForce
        mkMerge
        ;
      configType = config.wayland.windowManager.hyprland.configType;

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
        # split-monitor-workspaces discovers hy3 while loading its integration.
        plugins = mkBefore [ hy3 ];

        settings = mkMerge [
          (hyprlandLib.mkConfig configType {
            general.layout = mkForce "hy3";
          })
          (hyprlandLib.mkBinds configType (
            [
              {
                key = "T";
                dispatcher = "hy3:makegroup";
                argument = "tab";
                lua = "hl.plugin.hy3.make_group(\"tab\")";
              }
              {
                key = "H";
                dispatcher = "hy3:makegroup";
                argument = "h";
                lua = "hl.plugin.hy3.make_group(\"h\")";
              }
              {
                key = "U";
                dispatcher = "hy3:makegroup";
                argument = "v";
                lua = "hl.plugin.hy3.make_group(\"v\")";
              }
              {
                key = "A";
                dispatcher = "hy3:changefocus";
                argument = "raise";
                lua = "hl.plugin.hy3.change_focus(\"raise\")";
              }
              {
                modifiers = [
                  "SUPER"
                  "SHIFT"
                ];
                key = "A";
                dispatcher = "hy3:changefocus";
                argument = "lower";
                lua = "hl.plugin.hy3.change_focus(\"lower\")";
              }
            ]
            ++
              map
                (direction: {
                  key = direction;
                  dispatcher = "hy3:movefocus";
                  argument = direction;
                  lua = "hl.plugin.hy3.move_focus(\"${direction}\")";
                })
                [
                  "left"
                  "right"
                  "up"
                  "down"
                ]
            ++
              map
                (direction: {
                  modifiers = [
                    "SUPER"
                    "CTRL"
                  ];
                  key = direction;
                  dispatcher = "hy3:movewindow";
                  argument = direction;
                  lua = "hl.plugin.hy3.move_window(\"${direction}\")";
                })
                [
                  "left"
                  "right"
                  "up"
                  "down"
                ]
          ))
        ];
      };
    };
}
