{
  flake.modules.homeManager.mako-notifier = { config, ... }: {
    assertions = [
      {
        assertion =
          (config.modules.desktop.notifications.backend == "quickshell") != config.services.mako.enable;
        message = "exactly one notification daemon must own the session";
      }
    ];

    services.mako = {
      enable = config.modules.desktop.notifications.backend == "mako";
      settings = {
        "app-name~=\".*[Mm]aestral.*\" summary=\"Sync error\"" = {
          on-notify = "dismiss --no-history";
        };

        "desktop-entry=maestral summary=\"Sync error\"" = {
          on-notify = "dismiss --no-history";
        };

        "summary=\"Sync error\" body~=\"^Could not upload\"" = {
          on-notify = "dismiss --no-history";
        };
      };
    };
  };
}
