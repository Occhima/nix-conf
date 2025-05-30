# NOTE: Stolen from https://discourse.nixos.org/t/yazi-plugin-eza-preview-not-working/64474
{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "yazi" cfg.tools) {

    programs = {
      yazi = {
        enable = true;
        shellWrapperName = "y";
        plugins = with pkgs.yaziPlugins; {
          full-border = full-border;
          ouch = ouch;
          vcs-files = vcs-files;
          smart-enter = smart-enter;
          git = git;
          toggle-pane = toggle-pane;
        };

        keymap = {
          manager = {
            prepend_keymap = [
              {
                on = "T";
                run = "plugin toggle-pane max-preview";
                desc = "Show or hide the preview pane";
              }

              {
                on = "l";
                run = "plugin smart-enter";
                desc = "Enter the child directory, or open the file";
              }
              {
                on = [
                  "g"
                  "c"
                ];
                run = "plugin vcs-files";
                desc = "Show Git File changes";
              }
            ];
          };
        };

        settings = {
          plugin = {
            prepend_fetchers = [
              {
                id = "git";
                name = "*";
                run = "git";
              }
              {
                id = "git";
                name = "*/";
                run = "git";
              }
            ];

            prepend_previewers = [
              {
                name = "*/";
                run = "eza-preview";
              }
            ];
          };
        };

        initLua = # lua
          ''
            -- For full-border plugin
            require("full-border"):setup {
              type = ui.Border.ROUNDED,
            }

            -- for git.yazi
            require("git"):setup()
          '';

      };
    };
  };
}
