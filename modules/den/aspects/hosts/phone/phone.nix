{
  config,
  den,
  hm,
  lib,
  ...
}:
{
  den.aspects.phone.nixOnDroid = {
    imports = [ config.flake.modules.nixOnDroid.droid-base ];
    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      config.imports = [ config.den.homes.aarch64-linux.phone-home.mainModule ];
    };
  };

  den.aspects.phone-home = {
    includes = [
      (hm "home")
      (hm "neovim")
      den.aspects.shell
    ];
    homeManager.home = {
      username = lib.mkDefault "nix-on-droid";
      homeDirectory = lib.mkDefault "/data/data/com.termux.nix/files/home";
    };
  };
}
