{
  config,
  inputs,
  ...
}:
let
  inherit (inputs) haumea;
  modules = haumea.lib.load {
    src = ./.;
    inputs = {
      inherit inputs config;
    };
  };
in
modules
