{ occhima, ... }:
{
  occhima.cli-shell.includes = with occhima; [
      atuin
      zoxide
      direnv
      nix-your-shell
      navi
      pay-respects
    ];
}
