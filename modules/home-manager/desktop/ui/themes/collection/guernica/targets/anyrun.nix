{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;
in
{
  programs.anyrun = mkIf (cfg.enable && cfg.name == "guernica") {
    extraCss = ''
      * {
            all: unset;
            border-radius: 0;
        }

        #window {
            background: rgba(0, 0, 0, 0);
            padding: 48px;
        }

        box#main {
            margin: 48px;
            padding: 24px;
            background-color: rgba(31, 31, 31, .6);
            box-shadow: 0 0 2px 1px rgba(26, 26, 26, 238);
            border: 2px solid #fff;
        }

        #entry { /* I would center align the text, but GTK doesn't support it */
            border-bottom: 2px solid #fff;
            margin-bottom: 12px;
            padding: 6px;
            font-family: monospace;
        }

        #match {
            padding: 4px;
        }

        #match:selected,
        #match:hover {
            background-color: rgba(255, 255, 255, .2);
        }

        label#match-title {
            font-weight: bold;
        }
    '';

  };

}
