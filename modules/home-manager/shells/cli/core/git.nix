{ ... }:
{
  occhima.git.homeManager = (
    {
      pkgs,
      config,
      ...
    }:
    {
      config = {
        programs.delta = {
          enable = true;
          options = {
            navigate = true;
            light = false;
            side-by-side = true;
          };
        };

        programs.git = {
          enable = true;
          package = pkgs.gitFull;

          settings = {
            color.ui = "auto";
            user = {
              name = config.home.username;
              email = config.accounts.email.accounts.usp.address;
            };

            diff = {
              algorithm = "histogram"; # better diff algorithm
              colorMoved = "default";
            };

            pull.rebase = true;
            rebase = {
              autoSquash = true;
              autoStash = true;
            };
            merge.ff = "only";
            push.autoSetupRemote = true;

            init.defaultBranch = "main";

            transfer.fsckObjects = true;
            fetch.fsckObjects = true;
            receive.fsckObjects = true;
          };
        };
      };
    }
  );
}
