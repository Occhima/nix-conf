# Host: voyager — ISO/installer.
# ponytail: minimal aspect, voyager is an ISO image builder not a real host.
{
  inputs,
  ...
}:
{
  config.flake.modules.nixos.voyager = {
    imports = with inputs.self.modules.nixos; [
      iso-base
    ];
    config = {
      networking.hostName = "voyager";
    };
  };
}
