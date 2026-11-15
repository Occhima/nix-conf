{
  flake.modules.nixos.lix =
    { pkgs, ... }:
    {
      nix = {
        package = pkgs.lixPackageSets.stable.lix;
        settings.experimental-features = [
          "lix-custom-sub-commands"
          "pipe-operator"
        ];
      };

      environment.systemPackages = [ pkgs.lix-diff ];
    };
}
