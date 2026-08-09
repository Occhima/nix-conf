;;; +casual.el -*- lexical-binding: t; -*-

(use-package! casual
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
  (map! :leader
        :prefix ("o C" . "casual")
        :desc "Calc"          "c" #'casual-calc-tmenu
        :desc "Dired"         "d" #'casual-dired-tmenu
        :desc "EditKit"       "e" #'casual-editkit-main-tmenu
        :desc "IBuffer"       "i" #'casual-ibuffer-tmenu
        :desc "Bookmarks"     "k" #'casual-bookmarks-tmenu
        :desc "Calendar"      "l" #'casual-calendar
        :desc "Info"          "n" #'casual-info-tmenu
        :desc "Re-Builder"    "r" #'casual-re-builder-tmenu
        :desc "EWW"           "w" #'casual-eww-tmenu
        :desc "EWW bookmarks" "W" #'casual-eww-bookmarks-tmenu)

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
