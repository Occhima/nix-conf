{ ... }:
{
  flake.modules.homeManager.finance =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
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
    };
}
