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
in
# podmanEnabled = config.modules.services.podman.enable;
# add maybe finance if podman enabled
# arion/maybe/default.nix <- from doot/nixos-config
{

  config = mkIf (hasProfile config [ "finance" ]) {
    home.packages = with pkgs; [
      beancount
      beancount-language-server

      #NOTE: Broken
      # fava

      hledger-ui
      hledger-web
    ];
    programs.ledger.enable = true;

    # services.podman = mkIf podmanEnabled {

    #   containers = {

    #     maybeFinanceRedis = { };
    #     maybeFinanceDb = { };
    #     autoStart = true;
    #     image = "postgres:latest";
    #   };
    #   maybeFinanceWorker = { };
    #   maybeFinanceWeb = { };

    # };

  };

}
