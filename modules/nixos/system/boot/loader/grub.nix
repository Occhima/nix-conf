{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr str;

  cfg = config.modules.system.boot.loader;
  cfgGrub = config.modules.system.boot.loader.grub;

  bigsurTheme = pkgs.stdenv.mkDerivation {
    name = "bigsur-grub2-theme";
    src = pkgs.fetchFromGitHub {
      owner = "Teraskull";
      repo = "bigsur-grub2-theme";
      rev = "5bf0a9711282e4463eec82bb4430927fdc9c662a";
      hash = "sha256-BSZHTd6Eg/QZ1ekGTd3W+xHI6RbSmwCrcDxaCWD/DbI=";
    };
    installPhase = "cp -r bigsur $out";
  };
in
{
  options.modules.system.boot.loader.grub = {
    device = mkOption {
      type = nullOr str;
      default = "nodev";
      description = "The device to install the bootloader to";
    };
  };

  config = mkIf (cfg.type == "grub") {
    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = cfgGrub.device;
        #efiInstallAsRemovable = true;
        theme = bigsurTheme;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
