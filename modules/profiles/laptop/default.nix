{

  imports = [
    ./power
    ./adb.nix
    ./touchpad.nix
    ./type.nix
  ];
  modules.device.type = "desktop";
}
