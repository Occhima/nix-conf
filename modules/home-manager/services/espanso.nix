{ config, ... }:
let
  inherit (config.flake.lib.custom) isWayland;
in
{
  flake.modules.homeManager.espanso =
    {
      config,
      lib,
      osConfig ? { },
      pkgs,
      ...
    }:
    let
      accounts = config.accounts.email.accounts;
      fullName = accounts.personal.realName;
      usingWayland = isWayland osConfig;
      uuidgen = lib.getExe' pkgs.util-linux "uuidgen";
    in
    {
      config = {
        services.espanso = {
          enable = true;
          waylandSupport = usingWayland;
          x11Support = !usingWayland;
          configs = {
            default = {
              auto_restart = true;
              toggle_key = "ALT";
              keyboard_layout.layout = config.home.keyboard.layout;
            };
          };
          matches = {
            global_vars.global_vars = [
              {
                name = "full_name";
                type = "echo";
                params.echo = fullName;
              }
            ];

            emails.matches = [
              {
                trigger = ";mail";
                label = "Choose an email address";
                replace = "{{email}}";
                vars = [
                  {
                    name = "email";
                    type = "choice";
                    params.values = [
                      {
                        label = "Personal";
                        id = accounts.personal.address;
                      }
                      {
                        label = "USP";
                        id = accounts.usp.address;
                      }
                      {
                        label = "Gmail";
                        id = accounts.gmail.address;
                      }
                    ];
                  }
                ];
              }
              {
                trigger = ";pmail";
                label = "Personal email";
                replace = accounts.personal.address;
              }
              {
                trigger = ";umail";
                label = "USP email";
                replace = accounts.usp.address;
              }
              {
                trigger = ";gmail";
                label = "Gmail address";
                replace = accounts.gmail.address;
              }
              {
                trigger = ";name";
                label = "Full name";
                replace = "{{full_name}}";
              }
              {
                trigger = ";sig";
                label = "English email signature";
                replace = "Best regards,\n{{full_name}}";
              }
              {
                trigger = ";attsig";
                label = "Portuguese email signature";
                replace = "Atenciosamente,\n{{full_name}}";
              }
            ];

            dates.matches = [
              {
                trigger = ";date";
                label = "ISO date";
                replace = "{{date}}";
                vars = [
                  {
                    name = "date";
                    type = "date";
                    params.format = "%Y-%m-%d";
                  }
                ];
              }
              {
                trigger = ";brdate";
                label = "Brazilian date";
                replace = "{{date}}";
                vars = [
                  {
                    name = "date";
                    type = "date";
                    params.format = "%d/%m/%Y";
                  }
                ];
              }
              {
                trigger = ";now";
                label = "Current date and time";
                replace = "{{timestamp}}";
                vars = [
                  {
                    name = "timestamp";
                    type = "date";
                    params.format = "%Y-%m-%d %H:%M";
                  }
                ];
              }
              {
                trigger = ";tomorrow";
                label = "Tomorrow's date";
                replace = "{{date}}";
                vars = [
                  {
                    name = "date";
                    type = "date";
                    params = {
                      format = "%Y-%m-%d";
                      offset = 86400;
                    };
                  }
                ];
              }
            ];

            productivity.matches = [
              {
                trigger = ";uuid";
                label = "Generate a UUID";
                replace = "{{uuid}}";
                vars = [
                  {
                    name = "uuid";
                    type = "shell";
                    params.cmd = uuidgen;
                  }
                ];
              }
              {
                trigger = ";mdlink";
                label = "Markdown link from clipboard";
                replace = "[{{link.text}}]({{clipboard}})";
                vars = [
                  {
                    name = "clipboard";
                    type = "clipboard";
                  }
                  {
                    name = "link";
                    type = "form";
                    params.layout = "Link text: [[text]]";
                  }
                ];
              }
              {
                trigger = ";code";
                label = "Fenced code block";
                form = ''
                  ```[[language]]
                  [[body]]
                  ```
                '';
                form_fields.body.multiline = true;
              }
              {
                trigger = ";todo";
                label = "Markdown task";
                replace = "- [ ] $|$";
              }
            ];

            symbols.matches = [
              {
                trigger = ";check";
                replace = "✓";
              }
              {
                trigger = ";cross";
                replace = "✗";
              }
              {
                trigger = ";arrow";
                replace = "→";
              }
              {
                trigger = ";dash";
                replace = "—";
              }
            ];
          };
        };
      };
    };
}
