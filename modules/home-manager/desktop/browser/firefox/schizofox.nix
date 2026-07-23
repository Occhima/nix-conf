{ inputs, ... }:
{
  flake-file.inputs.schizofox = {
    url = "github:schizofox/schizofox";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.browser-firefox =
    { pkgs, ... }:
    {
      imports = [ inputs.schizofox.homeManagerModule ];
      config = {
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
              {
                Name = "Startpage";
                Description = "Uses Google's indexer without its logging";
                Method = "GET";
                URLTemplate = "https://startpage.com/sp/search?query={searchTerms}";
              }
            ];
          };

          security = {
            sandbox.enable = true;
            userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
          };

          misc = {
            drm.enable = true;
            contextMenu.enable = true;
          };

          # Extensions come as versioned XPI packages from the pinned NUR
          # input (rycee firefox-addons), installed through schizofox's
          # policies — never from rolling `latest.xpi` URLs. tampermonkey is
          # unfree and adguard is not packaged in NUR, so both were dropped.
          extensions =
            let
              rycee = pkgs.nur.repos.rycee.firefox-addons;
              extDir = "{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
              installFrom = pkg: "file://${pkg}/share/mozilla/extensions/${extDir}/${pkg.addonId}.xpi";
            in
            {
              enableExtraExtensions = true;
              darkreader.enable = false;
              extraExtensions = {
                "sponsorBlocker@ajay.app".install_url = installFrom rycee.sponsorblock;
                "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".install_url = installFrom rycee.refined-github;
                "{d7742d87-e61d-4b78-b8a1-b469842139fa}".install_url = installFrom rycee.vimium;
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
    };
}
