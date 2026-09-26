;;; core-ui.el --- Minimal UI defaults -*- lexical-binding: t; -*-

(defconst occhima/fixed-font "Iosevka Comfy")
(defconst occhima/variable-font "Iosevka Nerd Font Mono")
(defconst occhima/symbol-font "Symbols Nerd Font Mono")
;; Doom's (font-spec :size 15) is 15 pixels, about 11.3 points at 96 DPI.
(defconst occhima/font-height 113)
(defconst occhima/font-weight 'semi-bold)
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
  (set-face-attribute 'default frame
                      :family occhima/fixed-font
                      :height occhima/font-height
                      :weight occhima/font-weight)
  ;; Relative heights keep these faces in step with `text-scale-adjust'.
  (set-face-attribute 'fixed-pitch frame
                      :family occhima/fixed-font :height 1.0 :weight occhima/font-weight)
  (set-face-attribute 'variable-pitch frame
                      :family occhima/variable-font :height 1.0 :weight 'normal)
  (occhima/apply-symbol-fontset frame))

(occhima/apply-fonts)

(setq frame-title-format "%b"
      undo-limit 80000000
      truncate-string-ellipsis "…"
      display-line-numbers-type 'relative
      which-key-idle-delay 0.3
      which-key-idle-secondary-delay 0)

(defun occhima/show-trailing-whitespace ()
  "Highlight trailing whitespace in the current buffer."
  (setq-local show-trailing-whitespace t))

(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode)
  (add-hook hook #'occhima/show-trailing-whitespace))

(column-number-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(winner-mode 1)

(use-package which-key
  :ensure nil
  :config
  (which-key-mode 1))

(provide 'core-ui)
;;; core-ui.el ends here
