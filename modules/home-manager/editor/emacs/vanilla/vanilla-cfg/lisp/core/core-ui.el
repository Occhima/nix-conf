;;; core-ui.el --- Minimal UI defaults -*- lexical-binding: t; -*-

(set-face-attribute 'default nil :family "Iosevka Comfy" :height 150 :weight 'semibold)
(set-face-attribute 'fixed-pitch nil :family "Iosevka Comfy" :height 150)
(set-face-attribute 'variable-pitch nil :family "Iosevka Nerd Font Mono" :height 150)

(setq frame-title-format "%b"
      undo-limit 80000000
      truncate-string-ellipsis "…"
      display-line-numbers-type 'relative
      show-trailing-whitespace t
      which-key-idle-delay 0.3
      which-key-idle-secondary-delay 0)

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(winner-mode 1)

(use-package which-key
  :diminish
  :config
  (which-key-mode 1))

(provide 'core-ui)
;;; core-ui.el ends here
