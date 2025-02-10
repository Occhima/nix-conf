{
  config = {

    system.stateVersion = "24.11";

    modules = {
      secrets = {
        agenix.enable = false;
      };
    };
  };

}
