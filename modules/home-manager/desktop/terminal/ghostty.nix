{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.terminal.kitty;
  terminalCfg = config.modules.desktop.terminal;
in
{
  options.modules.desktop.terminal.ghostty = {
    enable = mkEnableOption "Enable ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
    };
    home.sessionVariables = mkIf (terminalCfg.active == "ghostty") {
      TERMINAL = "ghostty";
    };
  };
}
