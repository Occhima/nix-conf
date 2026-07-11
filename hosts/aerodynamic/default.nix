{
  system = "x86_64-linux";
  class = "nixos";
  stateVersion = "25.05";
  deployable = false;

  profiles = [
    "laptop"
    "graphical"
  ];

  modules = [ ./configuration.nix ];
}
