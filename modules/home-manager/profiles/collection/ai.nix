# NOTE: Stolen from: https://github.com/s3igo/dotfiles/blob/82929b20af8f66acfbbc41a614fbfbb9de1385e6/home/aider.nix#L4
{
  pkgs,
  lib,
  config,
  self,
  osConfig,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (self.lib.custom) hasProfile;
  hasAgeKeys = osConfig.modules.secrets.agenix.enable or false;
  #
  # aiderWithKeys =
  #   let
  #     aider-chat = pkgs.aider-chat-with-playwright;
  #   in
  #   pkgs.runCommand "${aider-chat.name}-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
  #     mkdir -p $out/bin
  #     makeWrapper ${lib.getExe aider-chat} $out/bin/${aider-chat.meta.mainProgram} \
  #       --add-flags '--gemini-api-key $(cat ${osConfig.age.secrets.gemini-api-key.path})'
  #   '';
  # aiderPackage = if hasAgeKeys then aiderWithKeys else pkgs.aider-chat-with-playwright;
  aiderPackage = pkgs.aider-chat-with-playwright;
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
    weak-model = "openrouter/meta-llama/llama-4-scout";
  };
in

{
  config = mkIf (hasProfile config [ "ai" ]) {
    home = {
      packages = [
        aiderPackage
        pkgs.claude-code
        pkgs.python313Packages.google-generativeai
        # pkgs.datasette
      ];

      file.".aider.conf.yml".source = yamlFormat.generate "aider-conf" settings;

      sessionVariables = mkIf hasAgeKeys {
        OPENAI_API_KEY = "$( cat ${osConfig.age.secrets.openai-api-key.path} )";
        ANTHROPIC_API_KEY = "$( cat ${osConfig.age.secrets.aider-anthropic.path} )";
        GEMINI_API_KEY = "$( cat ${osConfig.age.secrets.gemini-api-key.path} )";
      };
    };
    programs.git.ignores = [ ".aider*" ];
    services = {
      ollama = {
        enable = true;
      };
    };
  };

}
