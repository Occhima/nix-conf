{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;
  colors = config.lib.stylix.colors;
in
{

  xdg.configFile."flake-themes/nyxt/theme.lisp" = mkIf (cfg.enable && cfg.name == "guernica") {
    enable = true;
    text = with colors; ''
      (defvar guernica-theme
        (make-instance 'theme:theme
                       :font-family "${config.stylix.fonts.monospace.name}"

           :background-color-   "${base00}"
           :background-color    "${base00}"
           :background-color+   "${base01}"
           :on-background-color "${base05}"

           ;; Primary
           :primary-color-      "${base03}"
           :primary-color       "${base04}"
           :primary-color+      "${base06}"
           :on-primary-color    "${base00}"

           ;; Secondary
           :secondary-color-    "${base02}"
           :secondary-color     "${base03}"
           :secondary-color+    "${base04}"
           :on-secondary-color  "${base05}"

           ;; Action (links/functions)
           :action-color-       "${base0D}"
           :action-color        "${base0D}"
           :action-color+       "${base0C}"
           :on-action-color     "${base00}"

           ;; Success
           :success-color-      "${base0B}"
           :success-color       "${base0B}"
           :success-color+      "${base0A}"
           :on-success-color    "${base00}"

           ;; Highlight / Variables
           :highlight-color-    "${base08}"
           :highlight-color     "${base08}"
           :highlight-color+    "${base0E}"
           :on-highlight-color  "${base00}"

           ;; Warning
           :warning-color-      "${base09}"
           :warning-color       "${base09}"
           :warning-color+      "${base0A}"
           :on-warning-color    "${base00}"
                                         ))

       (define-configuration (browser)
           (
           (theme guernica-theme)
           )
         )
    '';

  };
}
