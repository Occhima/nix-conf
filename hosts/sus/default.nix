{
  config = {
    system.stateVersion = "25.05"; # Did you read the comment?

    modules = {
      secrets = {
        agenix.enable = false;

      };
    };
  };

}
