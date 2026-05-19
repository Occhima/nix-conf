{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    concatLists
    concatStringsSep
    elem
    getExe
    imap0
    mapAttrsToList
    optional
    range
    ;

  hyprCfg = config.modules.desktop.ui.windowManagerOpts.hyprland;
  per = hyprCfg.workspaces.perMonitor;
  workspacePluginActive =
    hyprCfg.plugins.enable
    && (
      elem "hyprsplit" hyprCfg.plugins.enabledPlugins
      || elem "split-monitor-workspaces" hyprCfg.plugins.enabledPlugins
    );

  displays = osConfig.modules.hardware.monitors.displays or { };
  primaryName = osConfig.modules.hardware.monitors.primaryMonitorName or "";

  monitorList =
    let
      pairs = mapAttrsToList (k: v: {
        key = k;
        inherit (v) output;
      }) displays;
    in
    imap0 (
      i: m:
      m
      // {
        index = i;
        isPrimary = m.key == primaryName;
      }
    ) pairs;

  mkRule =
    monitor: slot:
    let
      id = monitor.index * per + slot;
      flags = [
        "monitor:${monitor.output}"
        "persistent:true"
      ] ++ optional (slot == 1 && monitor.isPrimary) "default:true";
    in
    "${toString id}, ${concatStringsSep ", " flags}";

  workspaceRules = concatLists (map (m: map (slot: mkRule m slot) (range 1 per)) monitorList);

  hl-focus-workspace = pkgs.writeShellApplication {
    name = "hl-focus-workspace";
    runtimeInputs = with pkgs; [
      hyprland
      jq
    ];
    text = ''
      slot="''${1:?usage: hl-focus-workspace <1-${toString per}>}"
      mon_index=$(hyprctl monitors -j | jq -r '[.[]] | map(.focused) | index(true) // 0')
      target=$(( mon_index * ${toString per} + slot ))
      exec hyprctl dispatch workspace "$target"
    '';
  };

  hl-move-workspace = pkgs.writeShellApplication {
    name = "hl-move-workspace";
    runtimeInputs = with pkgs; [
      hyprland
      jq
    ];
    text = ''
      slot="''${1:?usage: hl-move-workspace <1-${toString per}>}"
      mon_index=$(hyprctl monitors -j | jq -r '[.[]] | map(.focused) | index(true) // 0')
      target=$(( mon_index * ${toString per} + slot ))
      exec hyprctl dispatch movetoworkspacesilent "$target"
    '';
  };

  nativeBinds = concatLists (
    map (n: [
      "$mainMod, ${toString n}, exec, ${getExe hl-focus-workspace} ${toString n}"
      "$mainMod SHIFT, ${toString n}, exec, ${getExe hl-move-workspace} ${toString n}"
    ]) (range 1 per)
  );

  enabled = hyprCfg.enable && !workspacePluginActive && displays != { };
in
{
  config = mkIf enabled {
    home.packages = [
      hl-focus-workspace
      hl-move-workspace
    ];

    wayland.windowManager.hyprland.settings = {
      workspace = workspaceRules;
      bind = nativeBinds;
    };
  };
}
