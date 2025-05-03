{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.browser.firefox;

in
{
  imports = [ inputs.schizofox.homeManagerModule ];

  options.modules.desktop.browser.firefox = {
    enable = mkEnableOption "Enable Firefox browser";
  };
  config = mkIf cfg.enable {
    programs.schizofox = {
      enable = true;
      search = {
        defaultSearchEngine = "Brave";
        removeEngines = [
          "Google"
          "Bing"
          "Amazon.com"
          "eBay"
          "Twitter"
          "Wikipedia"
        ];
        searxUrl = "https://searx.be";
        searxQuery = "https://searx.be/search?q={searchTerms}&categories=general";
        addEngines = [
          {
            Name = "Etherscan";
            Description = "Checking balances";
            Alias = "!eth";
            Method = "GET";
            URLTemplate = "https://etherscan.io/search?f=0&q={searchTerms}";
          }
        ];
      };

      security = {
        sanitizeOnShutdown.enable = true;
        sandbox.enable = true;
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };

      misc = {
        drmFix = true;
        disableWebgl = false;
        contextMenu.enable = true;
      };

      extensions = {
        darkreader.enable = true;
        # extraExtensions = {
        # };
      };

      # bookmarks = [
      #   {
      #     Title = "Example";
      #     URL = "https://example.com";
      #     Favicon = "https://example.com/favicon.ico";
      #     Placement = "toolbar";
      #     Folder = "FolderName";
      #   }
      # ];

    };
  };

}
