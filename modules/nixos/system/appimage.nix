{
  flake.modules.nixos.appimage =
    {
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
