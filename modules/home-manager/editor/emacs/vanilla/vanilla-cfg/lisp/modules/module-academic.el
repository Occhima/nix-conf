;;; module-academic.el --- Bibliography and research notes -*- lexical-binding: t; -*-

(defconst occhima/bibliography-directory
  "~/Dropbox/projects/library/bibliography/")
(defconst occhima/bibliographies
  (mapcar (lambda (file)
            (expand-file-name file occhima/bibliography-directory))
          '("articles.bib" "books.bib" "misc.bib")))
(defconst occhima/pdf-articles-directory
  "~/Dropbox/projects/library/articles/")
(defconst occhima/pdf-books-directory
  "~/Dropbox/projects/library/books/")
(defconst occhima/library-paths
  (list occhima/pdf-articles-directory occhima/pdf-books-directory))
(defconst occhima/org-roam-directory
  "~/Dropbox/projects/org/roam/")

(use-package org-roam
  :after org
  :custom
  (org-roam-directory occhima/org-roam-directory)
  :config
  (org-roam-db-autosync-mode 1))

(use-package citar
  :after org
  :custom
  (citar-bibliography occhima/bibliographies)
  (citar-library-paths occhima/library-paths)
  (citar-notes-paths (list occhima/org-roam-directory))
  (citar-file-extensions '("pdf" "org" "md"))
  (citar-file-open-function #'find-file)
  (citar-templates
   '((main . "${author editor:55}     ${date year issued:4}     ${title:55}")
     (suffix . "  ${tags keywords keywords:40}")
     (preview . "${author editor} ${title}, ${journal publisher container-title collection-title booktitle} ${volume} (${year issued date}).\n")
     (note . "# Notes on ${author editor}, ${title}"))))

(use-package org-ref
  :after org
  :custom
  (bibtex-dialect 'biblatex)
  (org-ref-bibtex-pdf-download-dir occhima/pdf-articles-directory)
  (org-ref-show-equation-images-in-tooltips t)
  :config
  (require 'org-ref-arxiv)

  (defun occhima/arxiv-bulk-add-from-region (begin end)
    "Add each arXiv identifier between BEGIN and END to the article library."
    (interactive "r")
    (unless (use-region-p)
      (user-error "Select a region containing arXiv identifiers first"))
    (let ((text (buffer-substring-no-properties begin end))
          identifiers
          (start 0)
          (regexp "[0-9]\\{4\\}\\.[0-9]\\{5\\}"))
      (while (string-match regexp text start)
        (push (match-string 0 text) identifiers)
        (setq start (match-end 0)))
      (unless identifiers
        (user-error "No arXiv identifiers found in region"))
      (make-directory occhima/pdf-articles-directory t)
      (dolist (identifier (nreverse identifiers))
        (message "Adding arXiv:%s" identifier)
        (arxiv-get-pdf-add-bibtex-entry
         identifier
         (car occhima/bibliographies)
         occhima/pdf-articles-directory)
        (sleep-for 1)))))

(use-package scihub
  :ensure (scihub :host github :repo "emacs-pe/scihub.el")
  :custom
  (scihub-download-directory occhima/pdf-articles-directory)
  (scihub-fetch-domain 'scihub-fetch-domains-lovescihub))

(provide 'module-academic)
;;; module-academic.el ends here
