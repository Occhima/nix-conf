{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.shell;
in
{
  config = mkIf (cfg.type == "zsh") {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      # Basic configuration
      initExtra = ''
        bindkey -e

      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "colored-man-pages"
          "command-not-found"
        ];
        theme = "robyrussel";
      };
    };
  };
}
