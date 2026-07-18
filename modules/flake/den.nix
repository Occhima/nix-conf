# Den: hosts, users and output generation — nothing more. Features live
# in plain flake-parts `flake.modules.<class>.<name>` (no den vocabulary);
# only modules/hosts/ and modules/users/ speak den, wiring those modules
# into hosts, users and standalone homes. No namespace: den stays a thin,
# replaceable output layer.
{ inputs, lib, ... }:
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
