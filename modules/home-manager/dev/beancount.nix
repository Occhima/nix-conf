{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.beancount;
in
{
  options.modules.dev.beancount = {
    enable = mkEnableOption "Enable beancount ( Ledger alternative ) development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      beancount
      beancount-language-server

      #NOTE: broken
      # fava
    ];
  };
}
