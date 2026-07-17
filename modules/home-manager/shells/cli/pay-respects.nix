{ ... }:
{
  config.occhima.pay-respects.homeManager = (
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
    }
  );
}
