{
  flake.modules.homeManager.themes-guernica = {
    stylix.targets = {
      kitty.enable = false;
      ghostty.enable = false;
      rofi.enable = false;
      mako.enable = false;
      qutebrowser.enable = false;
      spicetify.enable = false;
      zen-browser.enable = false;
      waybar = {
        enable = false;
        addCss = false;
        enableCenterBackColors = false;
        enableLeftBackColors = false;
        enableRightBackColors = false;
      };

      zellij.enable = true;
      foliate = {
        enable = true;
        colors.enable = true;
      };
    };
  };
}
