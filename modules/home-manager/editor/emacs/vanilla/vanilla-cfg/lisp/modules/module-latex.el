;;; module-latex.el --- LaTeX authoring -*- lexical-binding: t; -*-

(require 'core-evil)

(defun occhima/latex-compile ()
  "Compile the current LaTeX master file."
  (interactive)
  (save-buffer)
  (TeX-command "LaTeX" #'TeX-master-file -1))

(use-package tex
  :ensure auctex
  :defer t
  :hook ((LaTeX-mode . visual-line-mode)
         (LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . cdlatex-mode)
         (LaTeX-mode . TeX-fold-mode)
         (LaTeX-mode . TeX-source-correlate-mode)
         (LaTeX-mode . eglot-ensure))
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-save-query nil)
  (TeX-PDF-mode t)
  (TeX-engine 'xetex)
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  (TeX-source-correlate-start-server t)
  (TeX-electric-sub-and-superscript t)
  :config
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

(use-package evil-tex
  :hook (LaTeX-mode . evil-tex-mode))

(occhima/local-leader LaTeX-mode
  "v" '(TeX-view :wk "View")
  "c" '(occhima/latex-compile :wk "Compile")
  "a" '(TeX-command-run-all :wk "Run all")
  "m" '(TeX-command-master :wk "Run a command")
  "p" '(preview-at-point :wk "Preview")
  "P" '(preview-clearout-at-point :wk "Unpreview")
  "f" '(TeX-fold-paragraph :wk "Fold paragraph")
  "F" '(TeX-fold-clearout-paragraph :wk "Unfold paragraph")
  "C-f" '(TeX-fold-clearout-buffer :wk "Unfold buffer")
  "t" '(reftex-toc :wk "Table of contents")
  "r" '(reftex-reference :wk "Insert reference")
  "l" '(reftex-label :wk "Insert label")
  "@" '(citar-insert-citation :wk "Insert citation"))

(defun occhima/pdf-hide-cursor ()
  "Hide the evil cursor, which blinks over rendered PDF pages."
  (setq-local evil-normal-state-cursor (list nil)))

(use-package cdlatex :defer t)
(use-package pdf-tools
  :ensure nil
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :hook (pdf-view-mode . occhima/pdf-hide-cursor)
  :config
  (pdf-tools-install-noverify)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil))

(use-package saveplace-pdf-view
  :after pdf-tools)

(provide 'module-latex)
;;; module-latex.el ends here
