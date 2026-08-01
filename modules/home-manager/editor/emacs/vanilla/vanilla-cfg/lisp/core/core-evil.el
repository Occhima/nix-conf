;;; core-evil.el --- Evil stack and states -*- lexical-binding: t; -*-

(defconst occhima/leader-key "SPC")
(defconst occhima/leader-alt-key "M-SPC")

(use-package undo-fu)

(use-package evil
  :ensure (:wait t)
  :demand t
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
  (evil-set-initial-state 'welcome-dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package general
  :ensure (:wait t)
  :demand t
  :after evil
  :config
  (general-define-key
   :states '(normal visual motion insert emacs)
   :keymaps 'override
   :prefix-map 'occhima/leader-map
   :prefix occhima/leader-key
   :non-normal-prefix occhima/leader-alt-key)

  (general-create-definer occhima/leader
    :keymaps 'occhima/leader-map)

  (general-create-definer occhima/local-leader
    :keymaps 'occhima/local-leader-map)

  (general-def
    :states 'normal
    "C-S-f" #'toggle-frame-fullscreen
    "C-=" #'text-scale-increase
    "C--" #'text-scale-decrease))

(provide 'core-evil)
;;; core-evil.el ends here
