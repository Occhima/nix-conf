{
  config = {
    modules = {
      home-manager.enable = true;

      # Shell configuration with zsh
      shell = {
        type = "zsh";

        # Starship prompt
        prompt.type = "starship";
      };
    };
  };
}
