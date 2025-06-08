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
  };
}
