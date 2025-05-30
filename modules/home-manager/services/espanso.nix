{
  config,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  # Check for Wayland
  displayType = osConfig.modules.system.display.type or "";
  isWayland = displayType == "wayland";

  cfg = config.modules.services.espanso;
in
{
  options.modules.services.espanso = {
    enable = mkEnableOption "Espanso text expander service";
  };

  config = mkIf cfg.enable {
    services.espanso = {
      enable = true;
      waylandSupport = isWayland;
      configs.default = {
        backend = "inject";
        evdev_modifier_delay = 10;
        inject_delay = 1;
        keyboard_layout.layout = "no";
        preserve_clipboard = true;
        search_shortcut = "ALT+Space"; # TODO: https://espanso.org/docs/configuration/options/#customizing-the-search-bar
      };

      matches.base.matches = [
        {
          trigger = ";test";
          replace = "Hello, Worl?";
        }
      ];
    };
  };
}
