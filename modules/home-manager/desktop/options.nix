{
  lib,
  config,
  ...

}:
let
  inherit (lib) mkOption types;
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    terminal = {
      active = mkOption {
        type = types.str;
        default = "kitty";
        description = "The active terminal";
        example = ''kitty '';
      };
    };
    browser = {
      active = mkOption {
        type = types.str;
        default = "firefox";
        description = "The active browser";
        example = ''kitty '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = config.modules.desktop.terminal.${cfg.terminal.active}.enable or false;
        message = "Active terminal not enabled!";
      }
      {
        assertion = config.modules.desktop.browser.${cfg.browser.active}.enable or false;
        message = "Active browser not enabled!";
      }
    ];
  };
}
