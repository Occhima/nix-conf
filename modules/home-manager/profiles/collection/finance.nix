{
  config,
  self,
  pkgs,
  lib,
  ...

}:
let
  inherit (lib) mkIf;
  inherit (self.lib.custom) hasProfile;
  podmanEnabled = config.modules.services.podman.enable;
in
# add maybe finance if podman enabled
# arion/maybe/default.nix <- from doot/nixos-config
{

  config = mkIf (hasProfile config [ "finance" ]) {
    home.packages = with pkgs; [
      beancount
      beancount-language-server
      fava
      hledger-ui
      hledger-web
    ];
    programs.ledger.enable = true;

    services.podman.containers = mkIf podmanEnabled {
      maybeFinanceDb = {
        autoStart = true;
        image = "postgres:latest";
      };
      maybeFinanceApp = { };

    };

  };
}
