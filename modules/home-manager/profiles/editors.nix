# Aggregate: editors in daily use.
{ occhima, ... }:
{
  occhima.editors.includes = with occhima; [
      neovim
      emacs
    ];
}
