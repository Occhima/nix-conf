{ inputs, ... }:
{
  flake-file.inputs.impermanence = {
    url = "github:nix-community/impermanence";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.impermanence =
    {
      ...
    }:

    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      options.modules.system.file-system.impermanence = {
      };

      config = {

        environment.persistence."/persist" = {
          hideMounts = true;
          files = [
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
          ];
          directories = [ "/var/lib" ];
        };
      };
    };
}
