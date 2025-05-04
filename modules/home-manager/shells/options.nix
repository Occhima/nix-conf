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
      type = types.enum [
        "zsh"
        "bash"
        "fish"
        "nushell"
      ];
      default = "zsh";
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
            "zoxide"
            "ripgrep"
            "lazygit"
            "jujutsu"
            "fastfetch"
          ]
        );
        default = [
          "atuin"
          "bat"
          "direnv"
          "eza"
          "fzf"
          "zoxide"
          "ripgrep"
          "gh"
          "ssh"
          "lazygit"
          "jujutsu"
          "fastfetch"
        ];
        description = "List of CLI tools to enable";
        example = ''[ "bat" "eza" "fzf" "git" ]'';
      };
    };
  };
}
