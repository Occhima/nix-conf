{ occhima, ... }:
{
  config.occhima.cli-core.includes = with occhima; [
      bat
      eza
      fzf
      ripgrep
      jq
      pandoc
    ];
}
