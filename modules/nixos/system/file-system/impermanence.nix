{ inputs, ... }: {

  flake-file.inputs.impermanence = {
    url = "github:nix-community/impermanence";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.impermanence =
    { config, lib, ... }:
    let
      cfg = config.modules.system.file-system.impermanence;
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      options.modules.system.file-system.impermanence = {
        files = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "System files kept under /persist.";
        };
        directories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "System directories kept under /persist.";
        };
      };

      config = {
        environment.persistence."/persist" = {
          hideMounts = true;
          files = lib.unique cfg.files;
          directories = lib.unique cfg.directories;
        };
      };
    };
}
