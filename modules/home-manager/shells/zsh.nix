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
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      dotDir = (strings.removePrefix (config.home.homeDirectory + "/") config.xdg.configHome) + "/zsh";
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
    home.shell.enableZshIntegration = true;
  };
}
