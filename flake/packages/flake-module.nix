{ self, inputs, ... }:
let
  inherit (inputs.nixos-generators) nixosGenerate;
  specialArgs = { inherit self inputs; };
in
{
  perSystem =
    {
      pkgs,
      system,
      self',
      ...
    }:
    {
      packages = {
        inherit (pkgs.callPackage ./scripts/package.nix { })
          run-vm
          scripts
          ;
        install-tools = pkgs.callPackage ./installer/package.nix { };
        docs = pkgs.callPackage ./docs/package.nix { };
        nyxt-unstable = pkgs.callPackage ./nyxt/package.nix { };

        # V2 Gnome installer
        gnome-installer = nixosGenerate {
          inherit system specialArgs;
          modules = [
            (
              { ... }:
              {
                boot.kernelParams = [ "copytoram" ];
                nix.settings.experimental-features = "nix-command flakes";
                environment.systemPackages = [ self'.packages.install-tools ];
              }
            )
          ];
          format = "gnome-installer-iso";
          customFormats.gnome-installer-iso =
            { modulesPath, ... }:
            {
              imports = [
                (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
              ];

              isoImage.squashfsCompression = "gzip -Xcompression-level 1";

              formatAttr = "isoImage";
              fileExtension = ".iso";
            };
        };
      };
    };
}
