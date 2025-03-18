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
          "oh-my-zsh"
          "oh-my-bash"
          "pure"
          "powerlevel10k"
          "none"
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
            "git"
            "gpg"
            "ripgrep"
          ]
        );
        default = [ ];
        description = "List of CLI tools to enable";
        example = ''[ "bat" "eza" "fzf" "git" ]'';
      };
    };
  };
}
