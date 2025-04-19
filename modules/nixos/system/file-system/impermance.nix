{
  config,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.system.file-system.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.modules.system.file-system.impermanence = {
    enable = mkEnableOption "impermanence for filesystems";
  };

  config = mkIf cfg.enable {

    # don't know if this is actually necessary
    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [ "/var/lib" ];
    };
  };
}
