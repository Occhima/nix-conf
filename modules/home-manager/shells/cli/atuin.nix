{
  flake.modules.homeManager.atuin = {
    # Atuin is enabled when requested in tools list
    config = {
      programs.atuin = {
        enable = true;

        flags = [
          "--disable-up-arrow"
        ];

        settings = {
          show_preview = true;
          inline_height = 30;
          style = "compact";
          update_check = false;
          sync_frequency = "5m";
        };
      };
    };
  };
}
