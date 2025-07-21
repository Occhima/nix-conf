{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
  yamlFormat = pkgs.formats.yaml { };
  settings = {
    attribute-author = false;
    attribute-committer = false;
    auto-commits = false;
    cache-prompts = true;
    cache-keepalive-pings = 12;
    chat-language = "English";
    dark-mode = true;
    model = "gemini";
  };
  aiderPackage = pkgs.aider-chat-with-playwright;
  cond = cfg.enable && builtins.elem "aider" cfg.tools;
in
{
  config = mkIf cond {
    home = {
      packages = [ aiderPackage ];
      file.".aider.conf.yml".source = yamlFormat.generate "aider-conf" settings;
    };
    programs.git.ignores = [ ".aider*" ];
  };
}
