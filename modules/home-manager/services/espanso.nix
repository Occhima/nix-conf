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
      x11Support = !isWayland osConfig;
      configs = {
        default = {
          auto_restart = true;
          toggle_key = "ALT";
          keyboard_layout.layout = "${config.home.keyboard.layout}";
        };
      };
      matches = {
        emails.matches = [
          {
            trigger = ";pmail";
            replace = config.accounts.email.accounts.personal.address;
          }
          {
            trigger = ";umail";
            replace = config.accounts.email.accounts.usp.address;
          }
        ];
      };
    };
  };
}
