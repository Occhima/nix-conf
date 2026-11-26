{
  flake.modules.homeManager.calibre =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop.apps.calibre;

      iconTheme = pkgs.fetchurl {
        url = "https://code.calibre-ebook.com/icon-themes/awesomecalibre/icons.zip.xz";
        hash = "sha256-+P9+a2CLS7kVw3p9bP9ssU1FFlZeMI6XB4FGyXjDSdg=";
      };

      icons =
        pkgs.runCommand "calibre-icons"
          {
            nativeBuildInputs = [
              pkgs.xz
              pkgs.unzip
              pkgs.imagemagick
            ];
          }
          ''
            xz -dc ${iconTheme} > icons.zip
            unzip -q icons.zip -d $out
            ${lib.optionalString (cfg.iconColor != null) ''
              find $out -name '*.png' -not -path '*/plugins/*' -print0 \
                | xargs -0 -I{} magick {} -fill '${cfg.iconColor}' -colorize 100 {}
            ''}
          '';

      calibrePkgs =
        if pkgs.config.cudaSupport or false then
          import pkgs.path {
            inherit (pkgs.stdenv.hostPlatform) system;
            config = pkgs.config // {
              cudaSupport = false;
            };
          }
        else
          pkgs;

      appearance = {
        toolbar_icon_size = "medium";
        toolbar_text = "never";
        cover_corner_radius = 4;
        cover_corner_radius_unit = "%";
        cover_grid_spacing = 8;
        cover_grid_show_title = true;
        cover_grid_text_flush_bottom = true;
        cover_browser_reflections = false;
        book_list_extra_row_spacing = 4;
        tag_browser_old_look = false;
        tag_browser_item_padding = 0.8;
        tag_browser_hide_empty_categories = true;
        action-layout-toolbar = [
          "Add Books"
          "Edit Metadata"
          null
          "Convert Books"
          "View"
          "Tweak ePub"
          null
          "Choose Library"
          "Save To Disk"
          "Remove Books"
          null
          "Preferences"
        ];
      };

      appearanceFile = (pkgs.formats.json { }).generate "calibre-appearance.json" cfg.gui;

      mergeAppearance = pkgs.writers.writePython3Bin "calibre-merge-appearance" { } ''
        import json
        import os
        import sys

        target, overlay = sys.argv[1], sys.argv[2]

        current = {}
        if os.path.exists(target):
            try:
                with open(target, encoding="utf-8") as handle:
                    current = json.load(handle)
            except (OSError, ValueError):
                current = {}

        with open(overlay, encoding="utf-8") as handle:
            current.update(json.load(handle))

        parent = os.path.dirname(target)
        if parent:
            os.makedirs(parent, exist_ok=True)
        scratch = target + ".hm-new"
        with open(scratch, "w", encoding="utf-8") as handle:
            json.dump(current, handle, indent=2, sort_keys=True)
        os.replace(scratch, target)
      '';
    in
    {
      options.modules.desktop.apps.calibre = {
        gui = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
          description = "Keys merged into calibre's gui.json on activation; themes add their palette here.";
        };

        iconColor = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Recolor the monochrome icon theme to this color.";
        };
      };

      config = {
        modules.desktop.apps.calibre.gui = appearance;

        programs.calibre = {
          enable = true;
          package = calibrePkgs.calibre;
        };

        xdg.configFile."calibre/resources/images".source = icons;

        home.activation.calibreAppearance = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ${lib.getExe mergeAppearance} \
            ${config.xdg.configHome}/calibre/gui.json \
            ${appearanceFile}
        '';
      };
    };
}
