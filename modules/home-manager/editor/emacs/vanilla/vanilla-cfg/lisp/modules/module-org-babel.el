;;; module-org-babel.el --- Org Babel languages and export -*- lexical-binding: t; -*-

(defun occhima/org-babel-configure ()
  "Enable the Babel languages used by the current research workflow."
  (require 'org)
  (setq org-confirm-babel-evaluate nil
        org-babel-python-command "python3"
        org-latex-src-block-backend 'minted
        org-latex-packages-alist '(("" "minted")
                                   ("" "mdframed"))
        org-latex-compiler "xelatex"
        org-latex-minted-options '(("frame" . "lines")
                                   ("breaklines" . "true")
                                   ("fontsize" . "\\scriptsize")
                                   ("linenos" . "true")
                                   ("numbersep" . "5pt")
                                   ("tabsize" . "4")
                                   ("mathescape" . "true")
                                   ("showspaces" . "false"))
        org-latex-pdf-process
        '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (R . t)
     (shell . t)
     (latex . t))))

(add-hook 'elpaca-after-init-hook #'occhima/org-babel-configure)

(use-package jupyter
  :ensure nil
  :after org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   (cons '(jupyter . t) org-babel-load-languages))
  (setq org-babel-default-header-args:jupyter-python
        '((:async . "yes")
          (:session . "py")
          (:pandoc . t)
          (:kernel . "python3"))
        org-babel-default-header-args:jupyter-julia
        '((:async . "yes")
          (:session . "jl")
          (:pandoc . t)
          (:kernel . "julia-kernel-1.9"))
        org-babel-default-header-args:jupyter-R
        '((:async . "yes")
          (:session . "r")
          (:pandoc . t)
          (:kernel . "ir"))))

(provide 'module-org-babel)
;;; module-org-babel.el ends here
