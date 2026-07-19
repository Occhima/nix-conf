{
  flake.modules.homeManager.zellij =
    {
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
