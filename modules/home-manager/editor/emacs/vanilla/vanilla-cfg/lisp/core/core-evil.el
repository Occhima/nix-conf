;;; core-evil.el --- Evil stack and states -*- lexical-binding: t; -*-

(defconst occhima/leader-key "SPC")
(defconst occhima/local-leader-key ",")

(use-package undo-fu)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-want-Y-yank-to-eol t
        evil-want-fine-undo t
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package general
  :after evil
  :config
  (general-create-definer occhima/leadrr
    :states '(normal visual motion)
    :keymaps 'override
    :prefix occhima/leader-key
    :global-prefix "C-SPC")

  (defalias 'occhima/leader #'occhima/leadrr)

  (general-create-definer occhima/local-leader
    :states '(normal visual motion)
    :prefix occhima/local-leader-key))

(provide 'core-evil)
;;; core-evil.el ends here
