{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;
  usingHyprland = cfg.windowManager == "hyprland";
in
{
  config = mkIf (cfg.launcher == "anyrun") {
    programs.anyrun = {
      enable = true;

      config = {
        width = {
          fraction = 0.5;
        };
        hideIcons = false;

        plugins = [
          "${pkgs.anyrun}/lib/libapplications.so"
          # "${pkgs.anyrun}/lib/librink.so"
          "${pkgs.anyrun}/lib/libshell.so"
          "${pkgs.anyrun}/lib/libsymbols.so"
          # "${pkgs.anyrun}/lib/libtranslate.so"
          "${pkgs.anyrun}/lib/libwebsearch.so"
        ];

      };

      extraConfigFiles."websearch.ron".text = ''
        Config(
            prefix: "?",
            engines: [DuckDuckGo]
        )
      '';

    };

    wayland.windowManager.hyprland = mkIf usingHyprland {
      settings.bind = [
        "$mainMod, SPACE, exec, anyrun"
      ];
    };
  };
}
