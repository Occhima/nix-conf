{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.shell.cli;
in
{
  # Git is always enabled as a core tool
  config = {
    programs.git = {
      enable = true;

      # These would typically be user-specific options
      userName = config.home.username;
      userEmail = config.accounts.email.accounts.usp.address;

      # Enhanced features enabled only when explicitly requested in cli.tools
      delta = mkIf cfg.enable {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
        };
      };

      extraConfig = {
        # QoL improvements
        color.ui = "auto";

        diff = {
          algorithm = "histogram"; # better diff algorithm
          colorMoved = "default";
        };

        # Safer defaults
        pull.rebase = true;
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        merge.ff = "only";
        push.autoSetupRemote = true;

        # Standard practices
        init.defaultBranch = "main";

        # Data integrity
        transfer.fsckObjects = true;
        fetch.fsckObjects = true;
        receive.fsckObjects = true;
      };
    };
  };
}
