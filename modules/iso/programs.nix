{ pkgs, self', ... }:
{
  # needed packages for the installer
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      vim # we are not installing neovim here so we have a light dev environment
      pciutils # going to need this for lspci
      gitMinimal # we only need a basic git install
      age-plugin-yubikey
      ;
    inherit (self'.packages) install-tools;
  };

  hardware.enableRedistributableFirmware = true;
}
