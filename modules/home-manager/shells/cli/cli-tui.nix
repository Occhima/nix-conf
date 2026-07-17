{ occhima, ... }:
{
  occhima.cli-tui.includes = with occhima; [
      yazi
      zellij
      fastfetch
    ];
}
