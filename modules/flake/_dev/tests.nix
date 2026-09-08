{
  inputs,
  self,
  ...
}:
let
  # Test against the same helpers the flake exports, on top of a plain
  # nixpkgs lib (the flake never merges libs into `self.lib`).
  lib = inputs.nixpkgs.lib.extend (_: _: { inherit (self.lib) custom; });
in
{
  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem =
    { pkgs, inputs', ... }:
    {
      nix-unit = {
        allowNetwork = true;
        # fetchGit (IFD from nix-doom-emacs-unstraightened) shells out to `git`,
        # which the stock check sandbox does not provide.
        package = pkgs.runCommand "nix-unit-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
          mkdir -p $out/bin
          makeWrapper ${inputs'.nix-unit.packages.default}/bin/nix-unit $out/bin/nix-unit \
            --prefix PATH : ${pkgs.git}/bin
        '';
        tests = import ./tests/unit { inherit lib self; };
      };
    };
}
