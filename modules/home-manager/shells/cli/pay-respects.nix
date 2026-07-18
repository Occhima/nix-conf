{ ... }:
{
  flake.modules.homeManager.pay-respects =
    {
      config,
      ...
    }:
    {
      config = {
        programs.pay-respects = {
          enable = true;
          # alias = "F";
          # aiIntegration = configuredAiSupport;
        };
      };
    };
}
