{
  config,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.custom) isWayland;

  cfg = config.modules.services.espanso;
in
{
  options.modules.services.espanso = {
    enable = mkEnableOption "Espanso text expander service";
  };

  config = mkIf cfg.enable {
    services.espanso =
      let
        usingWayland = isWayland osConfig;
      in
      {
        enable = true;
        waylandSupport = usingWayland;
        x11Support = !usingWayland;
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
