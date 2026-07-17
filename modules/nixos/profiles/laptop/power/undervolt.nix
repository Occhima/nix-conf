{ ... }:
{
  occhima.laptop.nixos =
    { pkgs, config, ... }:
    {
      # ponytail: check cpu-intel's flag instead of old selector enum
      services.undervolt = {
        enable = config.hardware.cpu.intel.updateMicrocode or false;
        tempBat = 65;
        package = pkgs.undervolt;
      };
    };
}
