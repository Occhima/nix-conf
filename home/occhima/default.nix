{
  home = {
    username = "occhima";
  };

  modules = {
    shell = {
      enable = true;
      type = "zsh";
      prompt.type = "starship";

      # Enable CLI tools
      # Core tools (git, gpg) are always enabled
      cli = {
        enable = true;
        tools = [
          "atuin"
          "bat"
          "direnv"
          "eza"
          "fzf"
          "ripgrep"
        ];
      };
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
    };
  };
}
