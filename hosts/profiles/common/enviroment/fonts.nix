{ pkgs, ... }:
{
  fonts = {
    packages = [
      pkgs.nerd-fonts.iosevka
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      defaultFonts = {
        monospace = [ "Iosevka Nerd Font" ];
        sansSerif = [ "Iosevka Nerd Font" ];
        serif = [ "Iosevka Nerd Font" ];
        emoji = [ "Iosevka Nerd Font" ];
      };
    };

    fontDir.decompressFonts = true;
  };
}
