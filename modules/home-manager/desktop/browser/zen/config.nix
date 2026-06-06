# NOTE: another feature stolen from the isabelroses/dotfiles repo
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.browser.zen-beta;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.modules.desktop.browser.zen-beta = {
    enable = mkEnableOption "Enable Zen browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;

      policies = {
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
      };

      profiles.default = {
        # NOTE: the zen browser flake enables sine support
        mods = [
          "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
          "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
          "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
          "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
          "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
          "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        ];

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          refined-github
          enhanced-github
          foxyproxy-standard
          sponsorblock
          vimium
          to-deepl
          bonjourr-startpage
          search-by-image
          zen-internet
          foxytab
          owasp-penetration-testing-kit
        ];

        search = {
          force = true;
          default = "ddg";
          engines = {
            mynixos = {
              name = "My NixOS";
              urls = [
                {
                  template = "https://mynixos.com/search?q={searchTerms}";
                  params = [
                    {
                      name = "query";
                      value = "searchTerms";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nx" ];
            };
            github = {
              name = "GitHub Search";
              urls = [
                {
                  template = "https://github.com/search?q={searchTerms}";
                }
              ];
              definedAliases = [ "@gh" ];
            };
          };
        };
      };
      # nativeMessagingHosts = [ pkgs.firefoxpwa ];
    };

  };
}
