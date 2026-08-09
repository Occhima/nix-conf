;;; module-casual.el --- Casual transient menus -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package csv-mode)

(use-package casual
  :commands (casual-dired-tmenu
             casual-ibuffer-tmenu
             casual-bookmarks-tmenu
             casual-info-tmenu
             casual-calc-tmenu
             casual-re-builder-tmenu
             casual-editkit-main-tmenu
             casual-calendar
             casual-eww-tmenu
             casual-eww-bookmarks-tmenu)
  :init
  ;; isearch and ediff capture leader keys as search text / single-char
  ;; commands, so their tmenus must live on a raw key inside their own
  ;; keymap instead of the SPC o C prefix. Both override evil's state maps
  ;; while active, so C-o is safe there.
  (with-eval-after-load 'isearch
    (require 'casual-isearch)
    (keymap-set isearch-mode-map "C-o" #'casual-isearch-tmenu))

  (with-eval-after-load 'ediff
    (require 'casual-ediff)
    (casual-ediff-install)
    (add-hook 'ediff-keymap-setup-hook
              (lambda () (keymap-set ediff-mode-map "C-o" #'casual-ediff-tmenu))))

  ;; M-m isn't an evil binding, so these keep the raw key the docs suggest.
  (with-eval-after-load 'csv-mode
    (require 'casual-csv)
    (keymap-set csv-mode-map "M-m" #'casual-csv-tmenu))

  (with-eval-after-load 'bibtex
    (require 'casual-bibtex)
    (keymap-set bibtex-mode-map "M-m" #'casual-bibtex-tmenu))

  (with-eval-after-load 'elisp-mode
    (require 'casual-elisp)
    (keymap-set emacs-lisp-mode-map "M-m" #'casual-elisp-tmenu)))

(occhima/leader
  "o C" '(:prefix-command occhima/casual-map :wk "casual")
  "o C c" '(casual-calc-tmenu :wk "Calc")
  "o C d" '(casual-dired-tmenu :wk "Dired")
  "o C e" '(casual-editkit-main-tmenu :wk "EditKit")
  "o C i" '(casual-ibuffer-tmenu :wk "IBuffer")
  "o C k" '(casual-bookmarks-tmenu :wk "Bookmarks")
  "o C l" '(casual-calendar :wk "Calendar")
  "o C n" '(casual-info-tmenu :wk "Info")
  "o C r" '(casual-re-builder-tmenu :wk "Re-Builder")
  "o C w" '(casual-eww-tmenu :wk "EWW")
  "o C W" '(casual-eww-bookmarks-tmenu :wk "EWW bookmarks"))

(provide 'module-casual)
;;; module-casual.el ends here
