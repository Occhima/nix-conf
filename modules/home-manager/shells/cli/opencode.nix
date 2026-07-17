{ ... }:
{
  config.occhima.opencode.homeManager = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.opencode = {
          enable = true;
          enableMcpIntegration = true;

          settings = {
            autoupdate = false;
            share = "manual";
            plugin = [
              "oh-my-openagent@latest"
              "opencode-claude-auth@latest"
              "@mohak34/opencode-notifier"
              "@tarquinen/opencode-dcp"
              "@dietrichgebert/ponytail"
              "@simonwjackson/opencode-direnv"
              "harness-memory/plugin"
            ];

            permission = {
              read = {
                "*" = "allow";
                "./.env" = "deny";
                "./.env.*" = "deny";
                "./secrets/**" = "deny";
                "./venv/**" = "deny";
                "./config/credentials.json" = "deny";
                "./build" = "deny";
              };
            };
          };
        };
      };
    }
  );
}
