{ ... }:
{
  occhima.laptop.nixos =
    { pkgs, config, ... }:
    {
      hardware.acpilight.enable = false;
      services.acpid.enable = true;

      environment.systemPackages = with pkgs; [
        acpi
        powertop
      ];

      boot = {
        kernelModules = [ "acpi_call" ];
        extraModulePackages = with config.boot.kernelPackages; [
          acpi_call
          cpupower
        ];
      };
    };
}
