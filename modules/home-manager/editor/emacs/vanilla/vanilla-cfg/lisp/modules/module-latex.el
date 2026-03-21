;;; module-latex.el --- LaTeX authoring -*- lexical-binding: t; -*-

(use-package tex
  :elpaca auctex
  :defer t
  :hook ((LaTeX-mode . visual-line-mode)
         (LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . cdlatex-mode))
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-save-query nil)
  (TeX-PDF-mode t)
  (TeX-engine 'xetex)
  (TeX-view-program-selection '((output-pdf "PDF Tools"))))

(use-package cdlatex :defer t)
(use-package pdf-tools
  :defer t
  :config
  (pdf-tools-install))

(provide 'module-latex)
;;; module-latex.el ends here
