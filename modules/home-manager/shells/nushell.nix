{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.shell;

  nixosModuleSetShell = config.modules.hostContext.defaultShell;
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
