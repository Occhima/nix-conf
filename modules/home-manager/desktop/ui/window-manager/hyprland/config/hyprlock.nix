{
  config = {
    programs.hyprlock = {
      enable = true;

      settings = {

        general = {
          no_fade_in = true;
          no_fade_out = true;
          hide_cursor = false;
          grace = 0;
          disable_loading_bar = true;
        };
      };

    };

  };

}
