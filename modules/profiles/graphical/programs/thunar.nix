{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf config.garden.meta.thunar {
    garden.packages = {
      inherit (pkgs)
        ffmpegthumbnailer
        # needed to extract files
        xarchiver
        ;

      # packages necessary for thunar thumbnails
      inherit (pkgs.xfce) tumbler;
    };

    # thumbnail support on thunar
    services.tumbler.enable = true;

    # the thunar file manager
    # we enable thunar here and add plugins instead of in systemPackages
    programs.thunar = {
      enable = true;
      plugins = builtins.attrValues {
        inherit (pkgs.xfce) thunar-archive-plugin thunar-media-tags-plugin;
      };
    };
  };
}
