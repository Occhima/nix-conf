{ ... }:
{
  flake.modules.homeManager.pandoc =
    {
      config,
      ...
    }:
    {
      config = {
        programs.pandoc = {
          enable = true;
          defaults = {
            metadata = {
              author = "Marco Occhialini";
            };
            citeproc = true;
          };
        };
      };
    };
}
