{
  flake.modules.homeManager.fabric = {
    config = {
      programs.fabric-ai = {
        enable = true;
        enableYtAlias = true;
      };
    };
  };
}
