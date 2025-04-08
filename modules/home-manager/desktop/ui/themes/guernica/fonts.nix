{
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.nerd-fonts._0xproto ];
  stylix.fonts = {

    # for programs

    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    monospace = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 11;
      desktop = 11;
      terminal = 12;
    };
  };
}
