{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;

  desktopCfg = config.modules.desktop;
in
{
  config = mkIf (cfg.launcher == "anyrun") {
    programs.anyrun = {
      enable = true;

      config = {
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = true;
        showResultsImmediately = false;
        maxEntries = null;

        plugins = [
          "${pkgs.anyrun}/lib/libapplications.so"
          "${pkgs.anyrun}/lib/libshell.so"
          "${pkgs.anyrun}/lib/librink.so"
          "${pkgs.anyrun}/lib/libwebsearch.so"
          "${pkgs.anyrun}/lib/librandr.so"
          "${pkgs.anyrun}/lib/libnix_run.so"
        ];

      };

      extraConfigFiles."websearch.ron".text = ''
        Config(
            prefix: "?",
            engines: [DuckDuckGo]
        )
      '';

      extraConfigFiles."applications.ron".text = ''
        Config(
          desktop_actions: true,
          max_entries: 9,
          terminal: Some(Terminal(
            command: "${desktopCfg.terminal.active}",
            args: "-e {}")
          )
          )
      '';

      extraConfigFiles."nix-run.ron".text = ''
        Config(
          prefix: ":nr ",
          allow_unfree: false,
          channel: "nixpkgs-unstable",
          max_entries: 3,
        )
      '';

      extraConfigFiles."randr.ron".text = ''
        Config(
          prefix: ":dp",
          max_entries: 5,
        )
      '';

      extraConfigFiles."shell.ron".text = ''
        Config(
          prefix: ":sh",
          shell: None,
        )

      '';
    };

  };
}
