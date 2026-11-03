{
  flake.modules.homeManager.themes-guernica-foliate = { config, ... }: {
    # Keep Foliate's selectable reader fonts aligned with Guernica. We do not
    # force font overriding, so books that intentionally ship typography can
    # keep it unless the user enables Foliate's override-font option.
    programs.foliate.settings."viewer/font" = {
      serif = config.stylix.fonts.serif.name;
      "sans-serif" = config.stylix.fonts.sansSerif.name;
      monospace = config.stylix.fonts.monospace.name;
    };
  };
}
