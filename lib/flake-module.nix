{ inputs, ... }:
let
  inherit (inputs) nixpkgs;
  customLib = import ./. nixpkgs;
in
customLib
