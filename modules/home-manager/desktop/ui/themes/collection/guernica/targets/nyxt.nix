{
  flake.modules.homeManager.themes-guernica =
    { config, ... }:
    let
      colors = config.lib.stylix.colors;
      fonts = config.stylix.fonts;
    in
    {
      xdg.configFile."flake-themes/nyxt/theme.lisp" = {
        enable = true;
        text = with colors; ''
          (defvar guernica-theme
            (make-instance 'theme:theme
               :font-family           "${fonts.sansSerif.name}"
               :monospace-font-family "${fonts.monospace.name}"

               :background-color-   "#${base00}"
               :background-color    "#${base00}"
               :background-color+   "#${base01}"
               :on-background-color "#${base05}"

               :primary-color-      "#${base02}"
               :primary-color       "#${base03}"
               :primary-color+      "#${base05}"
               :on-primary-color    "#${base00}"

               :secondary-color-    "#${base01}"
               :secondary-color     "#${base02}"
               :secondary-color+    "#${base03}"
               :on-secondary-color  "#${base05}"

               :action-color-       "#${base09}"
               :action-color        "#${base0D}"
               :action-color+       "#${base05}"
               :on-action-color     "#${base00}"

               :success-color-      "#${base0A}"
               :success-color       "#${base0A}"
               :success-color+      "#${base05}"
               :on-success-color    "#${base00}"

               :highlight-color-    "#${base08}"
               :highlight-color     "#${base08}"
               :highlight-color+    "#${base0B}"
               :on-highlight-color  "#${base00}"

               :warning-color-      "#${base0E}"
               :warning-color       "#${base0E}"
               :warning-color+      "#${base08}"
               :on-warning-color    "#${base00}"))

          (define-configuration (browser)
            ((theme guernica-theme)))
        '';
      };
    };
}
