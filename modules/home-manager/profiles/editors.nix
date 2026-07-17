# Aggregate: editors in daily use.
{ occhima, ... }:
{
  config.occhima.editors.includes = with occhima; [
      neovim
      emacs
    ];
}
