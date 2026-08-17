# qutebrowser: keyboard-driven browser configured through the Home Manager
# options. Colors and fonts live in the guernica target, not here.
{
  flake.modules.homeManager.browser-qutebrowser =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.modules) mkIf;
    in
    {
      config = mkIf (pkgs.stdenv.hostPlatform.isLinux) {
        programs.qutebrowser = {
          enable = true;
          loadAutoconfig = true;

          searchEngines = {
            DEFAULT = "https://google.com/search?q={}";
            ax = "https://arxiv.org/search/?query={}&searchtype=all";
            arch = "https://aur.archlinux.org/packages?O=0&K={}";
            fl = "https://flathub.org/apps/search?q={}";
            git = "https://github.com/search?q={}";
            gs = "https://scholar.google.com/scholar?q={}";
            hm = "https://home-manager-options.extranix.com/?query={}";
            mn = "https://mynixos.com/search?q={}";
            no = "https://noogle.dev/?q.txt={}";
            npi = "https://github.com/NixOS/nixpkgs/issues?q={}";
            r = "https://old.reddit.com/search?q={}";
            yt = "https://yewtu.be/search?q={}";
          };

          aliases = {
            q = "close";
            qa = "quit";
            w = "session-save";
            wq = "quit --save";
          };

          quickmarks = {
            noogle = "https://noogle.dev";
            nixpkgs = "https://github.com/NixOS/nixpkgs";
            hm-options = "https://home-manager-options.extranix.com";
            nixos-search = "https://search.nixos.org/packages";
          };

          settings = {
            auto_save.session = true;
            changelog_after_upgrade = "never";

            completion = {
              height = "40%";
              quick = true;
              scrollbar = {
                padding = 2;
                width = 6;
              };
              shrink = true;
              timestamp_format = "%Y-%m-%d";
              web_history.max_items = 1000;
            };

            content = {
              autoplay = false;
              blocking = {
                enabled = true;
                method = "auto";
              };
              geolocation = false;
              javascript.clipboard = "ask";
              notifications.enabled = false;
              pdfjs = true;
            };

            downloads = {
              location.directory = "~/Downloads";
              position = "bottom";
              remove_finished = 5000;
            };

            editor.command = [
              "emacsclient"
              "-c"
              "+{line}:{column}"
              "{file}"
            ];

            hints = {
              chars = "dsjkhlfagnmxcweio";
              uppercase = false;
            };

            input.insert_mode.auto_load = false;

            scrolling = {
              bar = "when-searching";
              smooth = true;
            };

            statusbar = {
              show = "always";
              widgets = [
                "keypress"
                "url"
                "scroll"
                "history"
                "tabs"
                "progress"
              ];
            };

            tabs = {
              background = true;
              favicons.scale = 0.9;
              indicator.width = 0;
              last_close = "close";
              mode_on_change = "restore";
              position = "top";
              show = "multiple";
              title.format = "{audio}{current_title}";
            };

            url = {
              default_page = "about:blank";
              start_pages = [ "about:blank" ];
            };

            window = {
              hide_decoration = true;
              title_format = "{perc}{current_title}";
            };

            zoom.default = "100%";
          };

          keyBindings.normal = {
            "gf" = "view-source --pretty";
            "gm" = "open -t https://mynixos.com/search?q={primary}";
            "tt" = "config-cycle tabs.show multiple always";
            "ts" = "config-cycle statusbar.show always in-mode";
            "<Ctrl-Shift-e>" = "edit-url";
            ",o" = "yank inline [[{url}][{title}]]";
            ",m" = "yank inline [{title}]({url})";
            ",r" = "config-source";
          };

          extraConfig = ''
            c.statusbar.padding = {"top": 6, "bottom": 6, "left": 12, "right": 12}
            c.tabs.padding = {"top": 6, "bottom": 6, "left": 10, "right": 10}
          '';
        };
      };
    };
}
