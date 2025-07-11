{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.python;
in
{
  options.modules.dev.python = {
    enable = mkEnableOption "Enable Python development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ruff
      pyright
      ##uv
    ];

    programs.uv = {
      enable = true;
    };
    # programs.ruff.enable = true;
    programs.pyenv = {
      enable = true;
      rootDirectory = "${config.xdg.configHome}/pyenv";
    };
  };
}
