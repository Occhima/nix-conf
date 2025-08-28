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
in

{
  # TODO: I should turn this in to an enum, sometime
  config = mkIf (hasProfile config [ "ai" ]) {
    home = {
      packages = [
        pkgs.claude-code
        pkgs.python313Packages.google-generativeai
      ];

      sessionVariables = mkIf hasAgeKeys {
        OPENAI_API_KEY = "$( cat ${osConfig.age.secrets.openai-api-key.path} )";
        ANTHROPIC_API_KEY = "$( cat ${osConfig.age.secrets.aider-anthropic.path} )";
        GEMINI_API_KEY = "$( cat ${osConfig.age.secrets.gemini-api-key.path} )";
      };
    };
    services = {
      ollama = {
        enable = false;
      };
    };
  };

}
