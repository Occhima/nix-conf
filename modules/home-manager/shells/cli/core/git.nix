{
  lib,
  pkgs,
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
      package = pkgs.gitAndTools.gitFull;

      userName = config.home.username;
      userEmail = config.accounts.email.accounts.usp.address;

      delta = mkIf cfg.enable {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
        };
      };

      extraConfig = {
        color.ui = "auto";

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
