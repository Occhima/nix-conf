{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.system.appimage;
in
{
  options.modules.system.appimage = {
    enable = mkEnableOption "Enable AppImage support";
  };

  config = mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    programs.fuse.userAllowOther = true;
  };
}
