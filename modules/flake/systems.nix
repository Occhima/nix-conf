# Systems this flake evaluates `perSystem` outputs for.
{ inputs, ... }:
{
  systems = import inputs.systems;
}
