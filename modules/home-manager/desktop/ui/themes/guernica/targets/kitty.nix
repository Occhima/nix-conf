{
  # Disable stylix integration for kitty
  stylix.targets.kitty.enable = false;

  # Override font and theme settings
  programs.kitty = {
    font.name = "0xProto Nerd Font";
    themeFile = "Monokai_Soda";
  };
}
