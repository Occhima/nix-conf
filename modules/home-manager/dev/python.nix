{
  lib,
  config,
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

    programs.uv = {
      enable = true;
      settings = {
        index-strategy = "first-index";
        compile-bytecode = true;
        exclude-newer = "7 days";
      };
    };

    programs.pyenv = {
      enable = true;
      rootDirectory = "${config.xdg.configHome}/pyenv";
    };
  };
}
