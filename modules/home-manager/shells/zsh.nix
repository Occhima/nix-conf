{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.strings) removePrefix optionalString;
  cfg = config.modules.shell;
  cfgCli = config.modules.shell.cli;
  hasFzfSupport = builtins.elem "fzf" cfgCli.tools;
in
{
  config = mkIf (cfg.type == "zsh") {

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = false;
      initContent = (optionalString (builtins.elem "fastfetch" cfgCli.tools) "fastfetch");
      dotDir = (removePrefix (config.home.homeDirectory + "/") config.xdg.configHome) + "/zsh";
      plugins = [
        {
          name = "you-should-use";
          src = pkgs.zsh-you-should-use;
          file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
        }
        {
          name = "nix-zsh-completions";
          src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
        }
        {
          name = "nix-shell";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
        (mkIf hasFzfSupport {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        })
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "colored-man-pages"
          "dirhistory"
          "httpie"
          "urltools"
          "vi-mode"
        ];
      };
    };
  };
}
