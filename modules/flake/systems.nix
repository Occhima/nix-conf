# Systems this flake evaluates `perSystem` outputs for.
{ inputs, ... }:
{
  flake-file.inputs.systems.url = "github:nix-systems/default";

  systems = import inputs.systems;
}
