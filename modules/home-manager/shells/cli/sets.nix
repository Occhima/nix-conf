{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf concatMap mkAfter;
  cfg = config.modules.shell.cli;

  toolSetDefs = {
    core = [
      "bat"
      "eza"
      "fzf"
      "ripgrep"
      "jq"
      "pandoc"
    ];
    dev = [
      "distrobox"
    ];
    git = [
      "gh"
      "lazygit"
      "jujutsu"
    ];
    shell = [
      "atuin"
      "zoxide"
      "direnv"
      "nix-your-shell"
      "navi"
      "pay-respects"
    ];
    ai = [
      "claude-code"
      "opencode"
      "aider"
      "fabric"
      "jcode"
      "codegraph"
      "feynman"
    ];
    tui = [
      "yazi"
      "zellij"
      "fastfetch"
    ];
    security = [
      "ssh"
    ];
  };

  setTools = concatMap (s: toolSetDefs.${s} or [ ]) cfg.toolSets;
in
{
  config = mkIf cfg.enable {
    modules.shell.cli.tools = mkAfter setTools;
  };
}
