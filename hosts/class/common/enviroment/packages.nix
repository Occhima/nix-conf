{
  pkgs,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      git
      vim
    ];

  };

  programs.zsh.enable = true;
}
