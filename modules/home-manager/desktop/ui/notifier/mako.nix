{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.modules.desktop.ui;
  maestralCfg = config.modules.data.maestral;

in
{
  config = mkIf (cfg.notifier == "mako") {
    services.mako = {
      enable = true;
      settings = mkIf maestralCfg.enable {
        #HACK: annoying error
        "app-name=maestral summary=\"Sync error\"" = {
          invisible = 1;
        };
      };
    };
  };
}
