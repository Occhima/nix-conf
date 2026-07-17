{ inputs, ... }:
{
  flake.modules.homeManager.nixgl = (
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
