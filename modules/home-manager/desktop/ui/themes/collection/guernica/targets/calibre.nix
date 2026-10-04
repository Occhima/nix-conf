# Guernica styling for calibre. Explicit integration module: import it next to
# `calibre` and `themes-guernica`. Keeps calibre's own Qt style (crisper than
# Kvantum for its views) and feeds it a named dark palette plus book-details CSS.
{
  flake.modules.homeManager.themes-guernica-calibre =
    { config, lib, ... }:
    let
      colors = config.lib.stylix.colors;
      fonts = config.stylix.fonts;
      hex = name: "#${colors.${name}}";
      rgb =
        name:
        map (c: lib.toInt colors."${name}-rgb-${c}") [
          "r"
          "g"
          "b"
        ];
    in
    {
      modules.desktop.apps.calibre.gui = {
        color_palette = "dark";
        dark_palette_name = "guernica";
        dark_palettes.guernica = {
          Window = hex "base00";
          Base = hex "base00";
          AlternateBase = hex "base01";
          Button = hex "base01";
          ToolTipBase = hex "base01";
          Highlight = hex "base02";
          Accent = hex "base0E";
          Link = hex "base0D";
          LinkVisited = hex "base0C";
          WindowText = hex "base05";
          Text = hex "base05";
          ButtonText = hex "base05";
          ToolTipText = hex "base05";
          HighlightedText = hex "base05";
          BrightText = hex "base08";
          PlaceholderText = hex "base03";
          "WindowText-disabled" = hex "base03";
          "Text-disabled" = hex "base03";
          "ButtonText-disabled" = hex "base03";
          "HighlightedText-disabled" = hex "base03";
        };

        cover_grid_background = {
          migrated = true;
          dark = rgb "base00";
          light = rgb "base00";
          dark_texture = null;
          light_texture = null;
        };

        # [family point-size weight italic], as calibre's QFont(*font) expects.
        font = [
          fonts.sansSerif.name
          fonts.sizes.applications
          400
          false
        ];
      };

      # calibre reads user overrides of its resources from here.
      xdg.configFile."calibre/resources/templates/book_details.css".text = ''
        body, td { background-color: transparent; }
        body.horizontal table td.title { white-space: nowrap }
        a { text-decoration: none; color: ${hex "base0D"}; }
        .comments { margin-top: 0; padding-top: 0; text-indent: 0 }
        .comments h3, .comments-heading {
          font-size: larger;
          font-weight: bold;
          color: ${hex "base0E"};
        }
        table.fields { margin-bottom: 0; padding-bottom: 0; }
        table.fields td { vertical-align: top }
        table.fields td.title {
          font-weight: normal;
          font-style: italic;
          color: ${hex "base03"};
          text-align: right;
        }
        .series_name { font-style: italic; color: ${hex "base0B"}; }
      '';
    };
}
