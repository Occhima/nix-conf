(setq
 frame-title-format '"\n"          ; newline pushes resize info off the titlebar
 undo-limit 80000000
 evil-want-fine-undo t
 auto-save-default t
 truncate-string-ellipsis "…"
 display-line-numbers-type 'relative
 which-key-idle-delay 0.3
 which-key-idle-secondary-delay 0
 +workspaces-on-switch-project-behavior t
 evil-vsplit-window-right t
 evil-split-window-below t
 show-trailing-whitespace t
 doom-theme 'doom-polykai
 doom-font (font-spec :family "Iosevka Comfy" :size 15 :weight 'SemiBold)
 doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font Mono" :size 15)
 doom-symbol-font (font-spec :family "JuliaMono")
 doom-fallback-buffer-name "*dashboard*"
 fancy-splash-image "~/.config/doom/misc/splash/emacs.svg")

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(remove-hook '+dashboard-functions #'+dashboard-widget-shortmenu)

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
