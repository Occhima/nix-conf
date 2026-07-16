{ ... }:
{
  config.flake.modules.homeManager.nixgl = (
    {
      config,
      inputs,
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
