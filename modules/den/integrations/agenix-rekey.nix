{ config, ... }: {
  perSystem = {
    agenix-rekey.nixosConfigurations = {
      aerodynamic = config.flake.nixosConfigurations.aerodynamic;
      beyond = config.flake.nixosConfigurations.beyond;
      steammachine = config.flake.nixosConfigurations.steammachine;
    };
  };
}
