;;; core-evil.el --- Evil stack and states -*- lexical-binding: t; -*-

(defconst occhima/leader-key "SPC")
(defconst occhima/leader-alt-key "M-SPC")

(use-package undo-fu)

(use-package undo-fu-session
  :custom
  (undo-fu-session-directory
   (expand-file-name "undo-fu-session/" occhima/state-directory))
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (undo-fu-session-global-mode 1))

(use-package vundo
  :commands vundo
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))

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
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :after evil
  :config
  (evil-define-key '(normal visual) 'global "gc" #'evilnc-comment-operator))

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

  (general-def
    :states 'normal
    "C-S-f" #'toggle-frame-fullscreen
    "C-=" #'text-scale-increase
    "C--" #'text-scale-decrease))

(defun occhima/local-leader-keymap (mode)
  "Return the local leader keymap symbol for MODE, creating it on demand."
  (let ((symbol (intern (format "occhima/%s-local-leader-map" mode))))
    (unless (boundp symbol)
      (set symbol (make-sparse-keymap)))
    (put mode 'occhima/local-leader-map symbol)
    symbol))

(defun occhima/current-local-leader-map (&rest _)
  "Return the local leader keymap of the current major mode or its parents."
  (let ((mode major-mode) map)
    (while (and mode (not map))
      (setq map (get mode 'occhima/local-leader-map)
            mode (get mode 'derived-mode-parent)))
    (and map (symbol-value map))))

(defmacro occhima/local-leader (modes &rest bindings)
  "Bind BINDINGS below SPC m for each major mode in MODES."
  `(general-define-key
    :keymaps (mapcar #'occhima/local-leader-keymap (ensure-list ',modes))
    ,@bindings))

(provide 'core-evil)
;;; core-evil.el ends here
