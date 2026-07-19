{
  flake.modules.homeManager.pay-respects =
    {
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
