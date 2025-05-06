{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "pandoc" cfg.tools) {
    programs.pandoc = {
      enable = true;
      defaults = {
        metadata = {
          author = "Marco Occhialini";
        };
        citeproc = true;
      };
    };
  };
}
