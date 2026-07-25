{
  flake.modules.homeManager.mako-notifier = {
    services.mako = {
      enable = true;
      settings = {
        #HACK: annoying error
        "app-name=maestral summary=\"Sync error\"" = {
          invisible = 1;
        };
      };
    };
  };
}
