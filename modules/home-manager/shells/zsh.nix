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
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      dotDir = ".config/zsh";
      oh-my-zsh = {
        enable = true;
        # plugins = [
        #   "git"
        #   "colored-man-pages"
        #   "command-not-found"
        # ];
        # theme = "robyrussell";
      };
    };
  };
}
