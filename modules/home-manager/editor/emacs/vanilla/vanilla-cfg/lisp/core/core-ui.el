;;; core-ui.el --- Minimal UI defaults -*- lexical-binding: t; -*-
;; Code
(defconst occhima/fixed-font "Iosevka Comfy")
(defconst occhima/variable-font "Iosevka Nerd Font Mono")
(defconst occhima/symbol-font "Symbols Nerd Font Mono")
(defconst occhima/font-height 150)
(defconst occhima/symbol-font-ranges
  '((#xe000 . #xf8ff)
    (#xf0000 . #xfffff)))

(defvar occhima/symbol-fontset-applied nil)

(defun occhima/apply-symbol-fontset (&optional frame)
  "Route the Nerd Font private-use ranges on FRAME to `occhima/symbol-font'."
  (when (and (not occhima/symbol-fontset-applied)
             (fboundp 'set-fontset-font)
             (display-multi-font-p frame)
             (find-font (font-spec :family occhima/symbol-font)))
    (dolist (range occhima/symbol-font-ranges)
      (set-fontset-font t range occhima/symbol-font frame 'prepend))
    (setq occhima/symbol-fontset-applied t)))

(defun occhima/apply-fonts (&optional frame)
  "Set the configured font faces on FRAME, or globally when FRAME is nil."
  (dolist (spec (list (cons 'default occhima/fixed-font)
                      (cons 'fixed-pitch occhima/fixed-font)
                      (cons 'variable-pitch occhima/variable-font)))
    (set-face-attribute (car spec) frame
                        :family (cdr spec)
                        :height occhima/font-height
                        :weight 'normal))
  (occhima/apply-symbol-fontset frame))

(occhima/apply-fonts)


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
  :ensure nil
  :diminish
  :config
  (which-key-mode 1))

(provide 'core-ui)
;;; core-ui.el ends here
