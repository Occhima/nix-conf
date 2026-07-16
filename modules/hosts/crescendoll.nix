# Host: crescendoll — WSL.
{
  inputs,
  ...
}:
{
  config.flake.modules.nixos.crescendoll = {
    imports = with inputs.self.modules.nixos; [
      system-base
      accounts
      network
      security-auth
      wsl
    ];
    config = {
      modules.accounts = {
        enabledUsers = [ "occhima" ];
        mainUser = "occhima";
      };
      modules.network.hostName = "crescendoll";
    };
  };
}
