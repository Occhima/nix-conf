{ pkgs, ... }:
{
  programs = {
    git.enable = true;
    vim.enable = true;
  };

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
  ];
}
