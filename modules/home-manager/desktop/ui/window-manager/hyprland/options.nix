{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    types
    elem
    ;

  uiCfg = config.modules.desktop.ui;
  hyprCfg = uiCfg.windowManagerOpts.hyprland;

  pluginsActive = hyprCfg.plugins.enable;
  has = name: pluginsActive && elem name hyprCfg.plugins.enabledPlugins;
in
{
  options.modules.desktop.ui.windowManagerOpts.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = uiCfg.windowManager == "hyprland";
      description = "Wire up the Hyprland HM module and its plugin extras.";
    };

    workspaces.perMonitor = mkOption {
      type = types.ints.positive;
      default = 9;
      description = "Workspaces per monitor — also the stride between monitor offsets.";
    };

    plugins = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Master switch for hyprland plugins. When false, every entry in `enabledPlugins` is ignored.";
      };

      enabledPlugins = mkOption {
        type = types.listOf (
          types.enum [
            "hyprsplit"
            "split-monitor-workspaces"
            "hy3"
          ]
        );
        default = [ ];
      };
    };
  };

  config = lib.mkIf hyprCfg.enable {
    assertions = [
      {
        assertion = !(has "hyprsplit" && has "split-monitor-workspaces");
        message = ''
          modules.desktop.ui.windowManagerOpts.hyprland.plugins.enabledPlugins:
          "hyprsplit" and "split-monitor-workspaces" cannot be enabled at the
          same time — they bind the same dispatchers and Super+1..9 keys.
        '';
      }
    ];
  };
}
