{
  config,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf optionalString;

  cfg = config.modules.system.file-system.disko;
  hostname = config.networking.hostName;

  isVM =
    config.modules.virtualisation.vm.enable or false || config.services.qemuGuest.enable or false;

  configFilename = if isVM then "face2face.nix" else "${hostname}.nix";

  hostConfigExists = builtins.pathExists hostDiskoConfig;
  hostDiskoConfig = ./partitions/${configFilename};

  requestedConfig =
    optionalString isVM "(VM detected, using face2face.nix)"
    + optionalString (!isVM) "(using ${hostname}.nix)";
in
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  options.modules.system.file-system.disko = {
    enable = mkEnableOption "disk partitioning with disko";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hostConfigExists;
        message = "Disko is enabled but no partition configuration was found ${requestedConfig}. Create a file at ${toString hostDiskoConfig}";
      }
    ];

    disko.devices =
      let
        diskoConfig = import hostDiskoConfig;
      in
      diskoConfig.devices;
  };

}
