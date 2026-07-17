{ ... }:
{
  occhima.headless.nixos = {
    environment.variables.BROWSER = "echo";
  };
}
