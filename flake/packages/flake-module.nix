{
  ...
}:

# specialArgs = { inherit self inputs; };
{
  perSystem =
    {
      pkgs,
      # self',
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
        nyxt-source = pkgs.callPackage ./nyxt/package.nix { };
        antigravity = pkgs.callPackage ./antigravity/package.nix { };

        # vbox = nixosGenerate {
        #   system = "x86_64-linux";
        #   format = "virtualbox";
        # };
        # V2 Gnome installer
        # XXX: Uninstalling bc it's too heavy
        # gnome-installer = nixosGenerate {
        #   inherit system specialArgs;
        #   modules = [
        #     (
        #       { ... }:
        #       {
        #         boot.kernelParams = [ "copytoram" ];
        #         nix.settings.experimental-features = "nix-command flakes";
        #         environment.systemPackages = [
        #           self'.packages.install-tools
        #         ];
        #       }
        #     )
        #   ];
        #   format = "gnome-installer-iso";
        #   customFormats.gnome-installer-iso =
        #     { modulesPath, ... }:
        #     {
        #       imports = [
        #         (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
        #       ];

        #       isoImage.squashfsCompression = "gzip -Xcompression-level 1";

        #       formatAttr = "isoImage";
        #       fileExtension = ".iso";

        #     };
        # };
      };
    };
}
