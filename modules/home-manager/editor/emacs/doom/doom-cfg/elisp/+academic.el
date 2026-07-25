;;; +academic.el -*- lexical-binding: t; -*-

(defvar occhima/bibliography-directory
  "~/Dropbox/projects/library/bibliography/")

(defvar occhima/bibliographies
  (mapcar (lambda (file)
            (expand-file-name file occhima/bibliography-directory))
          '("articles.bib" "books.bib" "misc.bib")))

(defvar occhima/pdf-articles-dir
  "~/Dropbox/projects/library/articles/")

(defvar occhima/pdf-books-dir
  "~/Dropbox/projects/library/books/")

(defvar occhima/library-paths
  (list occhima/pdf-articles-dir occhima/pdf-books-dir))

(defvar occhima/org-roam-dir
  "~/Dropbox/projects/org/roam/")

(after! org-roam
  (setq org-roam-directory occhima/org-roam-dir
        org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section)))

(after! citar
  (setq citar-bibliography occhima/bibliographies
        citar-library-paths occhima/library-paths
        citar-notes-paths (list occhima/org-roam-dir)
        citar-file-extensions '("pdf" "org" "md")
        citar-file-open-function #'find-file
        citar-templates
        '((main . "${author editor:55}     ${date year issued:4}     ${title:55}")
          (suffix . "  ${tags keywords keywords:40}")
          (preview . "${author editor} ${title}, ${journal publisher container-title collection-title booktitle} ${volume} (${year issued date}).\n")
          (note . "# Notes on ${author editor}, ${title}"))))

(after! org-ref
  (require 'org-ref-arxiv)
  (setq bibtex-dialect 'biblatex
        org-ref-bibtex-pdf-download-dir occhima/pdf-articles-dir
        org-ref-show-equation-images-in-tooltips t)

  (defun occhima/arxiv-bulk-add-from-region (beg end)
    "Add each arXiv identifier between BEG and END to the article library."
    (interactive "r")
    (unless (use-region-p)
      (user-error "Select a region containing arXiv identifiers first"))
    (let ((text (buffer-substring-no-properties beg end))
          ids
          (start 0)
          (regexp "[0-9]\\{4\\}\\.[0-9]\\{5\\}"))
      (while (string-match regexp text start)
        (push (match-string 0 text) ids)
        (setq start (match-end 0)))
      (unless ids
        (user-error "No arXiv identifiers found in region"))
      (make-directory occhima/pdf-articles-dir t)
      (dolist (id (nreverse ids))
        (message "Adding arXiv:%s" id)
        (arxiv-get-pdf-add-bibtex-entry
         id (car occhima/bibliographies) occhima/pdf-articles-dir)
        (sleep-for 1)))))

(after! scihub
  (setq scihub-download-directory occhima/pdf-articles-dir
        scihub-fetch-domain 'scihub-fetch-domains-lovescihub))
