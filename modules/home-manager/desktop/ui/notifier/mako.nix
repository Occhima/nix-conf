{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;
in
{
  config = mkIf (cfg.notifier == "mako") {
    services.mako = {
      enable = true;
    };
  };
}
