{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;
  stylixColors = config.lib.stylix.colors;
in

{

  programs.anyrun = mkIf (cfg.enable && cfg.name == "guernica") {

    config = {
      x.fraction = 0.5; # at the middle of the screen
      y.fraction = 0.05; # at the top of the screen
      width.fraction = 0.3; # 30% of the screen
    };

    extraCss = # css
      with stylixColors; ''
        /* ===== Color variables ===== */
        :root {
          --bg-color: #${base00};
          --fg-color: #${base05};
          --primary-color: #${base04};
          --secondary-color: #${base03};
          --border-color: var(--primary-color);
          --selected-bg-color: var(--primary-color);
          --selected-fg-color: var(--bg-color);
        }

        /* ===== Global reset ===== */
        * {
          all: unset;
          font-family: "${config.stylix.fonts.monospace.name}", monospace;
        }

        /* ===== Transparent window ===== */
        window {
          background: transparent;
        }

        /* ===== Main container ===== */
        box.main {
          border-radius: 16px;
          background-color: color-mix(in srgb, var(--bg-color) 80%, transparent);
          border: 0.5px solid color-mix(in srgb, var(--fg-color) 25%, transparent);
          padding: 12px; /* add uniform padding around the whole box */
        }

        /* ===== Input field ===== */
        text {
          font-size: 1.3rem;
          background: transparent;
          border: 1px solid var(--border-color);
          border-radius: 16px;
          margin-bottom: 12px;
          padding: 5px 10px;
          min-height: 44px;
          caret-color: var(--primary-color);
        }

        /* ===== List container ===== */
        .matches {
          background-color: transparent;
        }

        /* ===== Single match row ===== */
        .match {
          font-size: 1.1rem;
          padding: 4px 10px; /* tight vertical spacing */
          border-radius: 6px;
        }

        /* Remove default label margins */
        .match * {
          margin: 0;
          padding: 0;
          line-height: 1;
        }

        /* Selected / hover state */
        .match:selected,
        .match:hover {
          background-color: var(--selected-bg-color);
          color: var(--selected-fg-color);
        }

        .match:selected label.plugin.info,
        .match:hover label.plugin.info {
          color: var(--selected-fg-color);
        }

        .match:selected label.match.description,
        .match:hover label.match.description {
          color: color-mix(in srgb, var(--selected-fg-color) 90%, transparent);
        }

        /* ===== Plugin info label ===== */
        label.plugin.info {
          color: var(--fg-color);
          font-size: 1rem;
          min-width: 160px;
          /* text-align: left; */
        }

        /* ===== Description label ===== */
        label.match.description {
          font-size: 0rem;
          color: var(--fg-color);
        }

        /* ===== Fade-in animation ===== */
        @keyframes fade {
          0% {
            opacity: 0;
          }
          100% {
            opacity: 1;
          }
        }

      '';

  };

}
