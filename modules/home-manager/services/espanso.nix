{
  config,
  lib,
  osConfig,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (self.lib.custom) isWayland;

  cfg = config.modules.services.espanso;
in
{
  options.modules.services.espanso = {
    enable = mkEnableOption "Espanso text expander service";
  };

  config = mkIf cfg.enable {
    services.espanso = {
      enable = true;
      waylandSupport = isWayland osConfig;
      configs.default = {
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
