{
  flake.modules.homeManager.calibre =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      iconTheme = pkgs.fetchFromGitHub {
        owner = "pan4ratte";
        repo = "calibre-modern-gnome";
        rev = "51a0fab710128d577f1821f972a6151eba832e13";
        hash = "sha256-fo3YeO/T/YFIWQ7rFoC5TFnIxMkG9eAQPWzqBrgwC6A=";
      };

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
      };

      appearanceFile = (pkgs.formats.json { }).generate "calibre-appearance.json" appearance;

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
      programs.calibre.enable = true;

      xdg.configFile."calibre/resources/images".source = "${iconTheme}/images";

      home.activation.calibreAppearance = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe mergeAppearance} \
          ${config.xdg.configHome}/calibre/gui.json \
          ${appearanceFile}
      '';
    };
}
