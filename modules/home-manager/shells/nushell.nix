{
  config,
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) getShellFromConfig;
  cfg = config.modules.shell;

  nixosModuleSetShell = getShellFromConfig osConfig config.home.username;
  usingNushell = (nixosModuleSetShell == "nushell") || cfg.type == "nushell";
in
{
  config = mkIf usingNushell {
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
        completions = {
          case_sensitive = false;
          quick = true;
          partial = true;
          algorithm = "fuzzy";
        };
      };
      plugins = with pkgs.nushellPlugins; [
        formats
        gstat
        query
        # net
        highlight
        polars
      ];
    };
  };
}
