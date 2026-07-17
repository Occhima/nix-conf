{ ... }:
{
  config.occhima.aider.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    let
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
    in
    {
      config = {
        home = {
          packages = [ aiderPackage ];
          file.".aider.conf.yml".source = yamlFormat.generate "aider-conf" settings;
        };
        programs.git.ignores = [ ".aider*" ];
      };
    }
  );
}
