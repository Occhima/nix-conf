{
  flake.modules.homeManager.pandoc =
    {
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
