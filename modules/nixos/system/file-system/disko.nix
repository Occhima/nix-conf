{ ... }:
{
  config.flake.modules.nixos.disko =
    {
      config,
      lib,
      inputs,
      ...
    }:

    let
      inherit (lib) optionalString;
      hostname = config.networking.hostName;

      isVM = config.services.qemuGuest.enable or false;

      configFilename = if isVM then "face2face.nix" else "${hostname}.nix";

      hostConfigExists = builtins.pathExists hostDiskoConfig;
      hostDiskoConfig = ./_partitions/${configFilename};

      requestedConfig =
        optionalString isVM "(VM detected, using face2face.nix)"
        + optionalString (!isVM) "(using ${hostname}.nix)";
    in
    {
      imports = [
        inputs.disko.nixosModules.disko
      ];

      options.modules.system.file-system.disko = {
      };

      config = {
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

    };
}
