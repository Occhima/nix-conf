{ ... }:
{
  flake.modules.homeManager.zellij =
    {
      config,
      ...
    }:
    {
      config = {
        programs.zellij = {
          enable = true;
          settings = {
            session_serialization = false;
          };
        };
      };
    };
}
