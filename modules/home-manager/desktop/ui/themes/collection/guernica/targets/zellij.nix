{ ... }:
{
  config.occhima.themes-guernica.homeManager =
    {
      ...
    }:
    {
      stylix.targets.zellij.enable = true;

      programs.zellij = {
        settings = {
          simplified_ui = true;
          pane_frames = true;
          # Modern aesthetics
          ui = {
            pane_frames = {
              rounded_corners = true;
              hide_session_name = false;
            };
          };

          copy_command = "wl-copy";
          copy_clipboard = "primary";
          copy_on_select = false;

          scroll_buffer_size = 10000;
          mouse_mode = true;

          session_serialization = false;
          pane_viewport_serialization = false;
          mirror_session = true;
          on_force_close = "detach";
        };
      };
    };
}
