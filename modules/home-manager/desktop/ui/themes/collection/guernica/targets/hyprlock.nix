# config stolen from : https://github.com/OrynVail/OrynOS
{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
in
{
  programs.hyprlock = themeLib.whenTheme config "guernica" {
    settings = {
      background = {
        monitor = "";
        blur_passes = 2;
      };

      "input-field" = {
        monitor = "";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = true;
        dots_rounding = -1;
        fade_on_empty = true;
        fade_timeout = 1000;
        placeholder_text = "<i>....</i>";
        hide_input = true;
        rounding = -1;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        fail_transition = 300;
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1;
        invert_numlock = false;
        swap_font_color = true;
        position = "0, 80";
        halign = "center";
        valign = "bottom";
      };

      label = {
        monitor = "";
        text = "$TIME";
        font_size = 90;
        font_family = config.stylix.fonts.monospace.name;
        position = "0, 0";
        halign = "center";
        valign = "center";
      };

    };
  };
}
