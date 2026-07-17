{ inputs, ... }:
{
  config.occhima.nixgl.homeManager = (
    {
      config,
      ...
    }:
    {
      config = {
        nixGL = {
          packages = inputs.nixgl.packages;
          defaultWrapper = "mesa";
          installScripts = [
            "mesa"
          ];
        };
      };
    }
  );
}
