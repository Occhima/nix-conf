{ config, ... }:
let
  inherit (config.flake.lib.custom) isWayland;
in
{
  flake.modules.homeManager.espanso =
    {
      config,
      osConfig ? { },
      ...
    }:
    {
      config = {
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
              # tbh = "to be honest";
              # btw = "by the way";
              # wdym = "what do you mean";
              # afaik = "as far as I know";
              # pls = "please";
              # iirc = "if I remember correctly";
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
    };
}
