{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.shell;

in
{
  config = mkIf (cfg.type == "nushell") {
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
        units
        query
        net
        highlight
      ];
    };
  };
}
