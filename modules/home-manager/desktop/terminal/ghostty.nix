{ ... }:
{
  config.occhima.terminal-ghostty.homeManager = {
    config = {
      programs.ghostty.enable = true;
      home.sessionVariables.TERMINAL = "ghostty";
      modules.desktop.terminal.active = "ghostty";
    };
  };
}
