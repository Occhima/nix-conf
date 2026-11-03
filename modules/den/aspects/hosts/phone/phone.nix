{
  config,
  den,
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
    includes = with den.aspects; [
      home-base
      shell
      editors
    ];
    homeManager.home = {
      username = lib.mkDefault "nix-on-droid";
      homeDirectory = lib.mkDefault "/data/data/com.termux.nix/files/home";
    };
  };
}
