{ ... }:
{
  occhima.mako-notifier.homeManager =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) mkIf;
      maestralCfg = config.modules.data.maestral;
    in
    {
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
