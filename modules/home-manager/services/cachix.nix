{ ... }:
{
  flake.modules.homeManager.cachix =
    {
      config,
      lib,
      osConfig ? { },
      ...
    }:
    {
      config = {
        services.cachix-agent = {
          name = "home-manager-${config.home.username}";
          enable = true;
          # Only available when running under NixOS with agenix secrets;
          # standalone Home Manager degrades to the default credentials lookup.
          credentialsFile = lib.mkIf (
            (osConfig.age.secrets or { }) ? cachix-key
          ) osConfig.age.secrets.cachix-key.path;
        };
      };
    };
}
