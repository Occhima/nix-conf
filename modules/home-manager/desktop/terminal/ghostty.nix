{
  flake.modules.homeManager.terminal-ghostty = {
    config = {
      programs.ghostty.enable = true;
      home.sessionVariables.TERMINAL = "ghostty";
      modules.desktop.terminal.active = "ghostty";
    };
  };
}
