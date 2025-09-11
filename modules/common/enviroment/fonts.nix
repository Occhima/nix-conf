{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs.nerd-fonts; [
      terminess-ttf
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

  };

}
