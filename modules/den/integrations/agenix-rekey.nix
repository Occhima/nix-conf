# agenix-rekey integration: registers the Den-generated NixOS configurations
# of hosts that rekey secrets. Lives inside the Den boundary because it
# consumes Den-generated flake outputs; plain host modules stay Den-free.
{ config, ... }: {
  perSystem = {
    agenix-rekey.nixosConfigurations = {
      aerodynamic = config.flake.nixosConfigurations.aerodynamic;
      beyond = config.flake.nixosConfigurations.beyond;
      steammachine = config.flake.nixosConfigurations.steammachine;
    };
  };
}
