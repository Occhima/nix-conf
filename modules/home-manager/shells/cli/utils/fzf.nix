{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "fzf" cfg.tools) {
    programs.fzf = {
      enable = true;

      enableZshIntegration = config.modules.shell.type == "zsh";
      enableBashIntegration = config.modules.shell.type == "bash";
      enableFishIntegration = config.modules.shell.type == "fish";

      # Use fd for find if available
      defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d --hidden --exclude .git";

      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--inline-info"
        "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
        "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
        "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      ];

      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:500 {}'"
      ];

      changeDirWidgetOptions = [
        "--preview '${pkgs.eza}/bin/eza --tree --level=2 --color=always {}'"
      ];
    };
  };
}
