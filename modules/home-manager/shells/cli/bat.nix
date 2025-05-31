{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "bat" cfg.tools) {
    programs.bat = {
      enable = true;

      config = {
        pager = "less -FR";
        color = "always";
        style = "plain";
        # theme = "Catppuccin-mocha";
      };

      # themes = {
      # };
    };

    # Alias cat to bat
    home.shellAliases = {
      cat = "bat";
    };
  };
}
