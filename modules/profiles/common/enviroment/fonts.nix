{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.iosevka
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      defaultFonts = {
        monospace = [ "Iosevka Nerd Font Mono" ];
        sansSerif = [ "Iosevka Nerd Font" ];
        serif = [ "Iosevka Nerd Font" ];
        emoji = [ "Iosevka Nerd Font" ];
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };
  };
}
