{
  flake.modules.homeManager.themes-guernica = { config, ... }: {
    # Foliate has a native Stylix target. Keep the application chrome on the
    # shared GTK target and let Stylix own the reader palette instead of
    # maintaining fragile application-specific CSS.
    stylix.targets.foliate = {
      enable = true;
      colors.enable = true;
    };

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
