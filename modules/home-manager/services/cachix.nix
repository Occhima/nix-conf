{ ... }:
{
  config.flake.modules.homeManager.cachix = (
    {
      config,
      osConfig,
      ...
    }:
    {
      config = {
        services.cachix-agent = {
          name = "home-manager-${config.home.username}";
          enable = true;
          credentialsFile = osConfig.age.secrets.cachix-key.path;
        };
      };
    }
  );
}
