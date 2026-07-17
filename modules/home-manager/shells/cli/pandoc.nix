{ ... }:
{
  config.occhima.pandoc.homeManager = (
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
    }
  );
}
