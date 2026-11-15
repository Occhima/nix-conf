{
  flake.modules.nixos.lix =
    { pkgs, lib, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      nix = {
        package = mkDefault pkgs.lixPackageSets.stable.lix;
        settings.experimental-features = [
          "lix-custom-sub-commands"
          "pipe-operator"
        ];
      };

      environment.systemPackages = [ pkgs.lix-diff ];
    };
}
