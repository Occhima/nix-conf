{ ... }:
{
  config.flake.modules.nixos.appimage =
    {
      config,
      ...
    }:

    {
      options.modules.system.appimage = {
      };

      config = {
        programs.appimage = {
          enable = true;
          binfmt = true;
        };
        programs.fuse.userAllowOther = true;
      };
    };
}
