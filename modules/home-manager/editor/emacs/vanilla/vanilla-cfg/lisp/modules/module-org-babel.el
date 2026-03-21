;;; module-org-babel.el --- Org Babel languages and eval flow -*- lexical-binding: t; -*-

(with-eval-after-load 'org
  (setq org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (R . t)
     (shell . t)
     (latex . t)))
  (setq org-babel-python-command "python3"
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
        org-latex-pdf-process '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")))

(provide 'module-org-babel)
;;; module-org-babel.el ends here
