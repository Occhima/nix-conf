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
        defaultSearchEngine = "Searx";
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
          {
            Name = "Startpage";
            Description = "Uses Google's indexer without its logging";
            Method = "GET";
            URLTemplate = "https://startpage.com/sp/search?query={searchTerms}";
          }
        ];
      };

      security = {
        sanitizeOnShutdown.enable = true;
        sandbox.enable = true;
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };

      misc = {
        drm.enable = true;

        # XXX: This is probably giving that annoying mesa.drivers warning
        disableWebgl = false;
        contextMenu.enable = true;
      };

      # stolen from: https://github.com/diniamo/niqs/blob/refs%2Fheads%2Fmain/home%2Fschizofox.nix
      extensions = {
        darkreader.enable = true;
        extraExtensions =
          let
            mkUrl = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
          in
          {
            "firefox@tampermonkey.net".install_url = mkUrl "tampermonkey";
            "sponsorBlocker@ajay.app".install_url = mkUrl "sponsorblock";
            "adguardadblocker@adguard.com".install_url = mkUrl "adguardadblocker";
            "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".install_url =
              "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}".install_url =
              "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          };
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
