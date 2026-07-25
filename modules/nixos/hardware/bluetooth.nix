{
  flake.modules.nixos.bluetooth = { pkgs, ... }: {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
      settings = {
        General = {
          JustWorksRepairing = "always";
        };
      };
    };

    environment.systemPackages = [ pkgs.bluetui ];
  };
}
