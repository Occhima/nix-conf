{
  lib,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.modules.shell = {
    enable = mkEnableOption "Enable shell configurations";

    type = mkOption {
      type = types.nullOr (
        types.enum [
          "zsh"
          "bash"
          "fish"
          "nushell"
        ]
      );
      default = null;
      description = "The shell to use as default";
    };

    prompt = {
      enable = mkEnableOption "Enable custom prompt";

      type = mkOption {
        type = types.enum [
          "starship"
          "powerlevel10k"
        ];
        default = "starship";
        description = "The prompt to use";
      };
    };

    cli = {
      enable = mkEnableOption "Enable CLI tools and utilities";

      toolSets = mkOption {
        type = types.listOf (
          types.enum [
            "core"
            "git"
            "shell"
            "ai"
            "tui"
            "security"
            "dev"
          ]
        );
        default = [ ];
        description = ''
          Predefined tool groups to enable.
          core: bat eza fzf ripgrep jq pandoc
          git: gh lazygit jujutsu
          shell: atuin zoxide direnv nix-your-shell navi pay-respects
          ai: claude-code opencode aider fabric jcode codegraph agentmemory feynman
          tui: yazi zellij fastfetch
          security: ssh
        '';
      };

      tools = mkOption {
        type = types.listOf (
          types.enum [
            "atuin"
            "bat"
            "direnv"
            "eza"
            "fzf"
            "gh"
            "ssh"
            "aider"
            "distrobox"
            "zoxide"
            "ripgrep"
            "lazygit"
            "jujutsu"
            "fastfetch"
            "pandoc"
            "zellij"
            "jq"
            "yazi"
            "claude-code"
            "fabric"
            "opencode"
            "navi"
            "pay-respects"
            "nix-your-shell"
            "jcode"
            "codegraph"
            "feynman"
          ]
        );
        default = [ ];
        description = "Individual CLI tools to enable, merged with toolSets";
        example = ''[ "bat" "eza" "fzf" ]'';
      };
    };
  };
}
