{ ... }:
{
  flake.modules.nixos.headless = {
    environment.variables.BROWSER = "echo";
  };
}
