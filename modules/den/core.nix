# Den core: input declarations, flakeModule import and the user-class schema.
# Den is a thin, replaceable output layer — every `den.*` definition lives
# under modules/den/. Plain modules elsewhere stay Den-free.
{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.den.url = "github:denful/den";

  # den builds standalone homes with inputs.home-manager (and the accounts
  # aspect imports its NixOS module), so the input is declared here.
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.den.flakeModule ];
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
