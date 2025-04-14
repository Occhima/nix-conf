{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
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
      uv
    ];

    # programs.ruff.enable = true;
    programs.pyenv.enable = true;
  };
}
