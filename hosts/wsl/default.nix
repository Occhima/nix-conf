{ ... }:
{
  config = {
    system.stateVersion = "25.05"; # Did you read the comment?
    modules = {
      device = {
        type = "wsl";
      };
    };
  };

}
