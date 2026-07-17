{ ... }:
{
  occhima.zellij.homeManager = (
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
    }
  );
}
