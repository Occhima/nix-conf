{
  config = {
    modules = {
      home.enable = true;
      shell = {
        type = "zsh";
        prompt.type = "starship";
      };
    };
  };
}
