;;; academic.el -*- lexical-binding: t; -*-

(defvar occhima/bib-articles
  "~/Dropbox/projects/library/bibliography/articles.bib")

(defvar occhima/bib-books
  "~/Dropbox/projects/library/bibliography/books.bib")

(defvar occhima/bib-misc
  "~/Dropbox/projects/library/bibliography/misc.bib")

(defvar occhima/bibliographies
  (list occhima/bib-articles
        occhima/bib-books
        occhima/bib-misc))

(defvar occhima/pdf-articles-dir
  "~/Dropbox/projects/library/articles/")

(defvar occhima/pdf-books-dir
  "~/Dropbox/projects/library/books/")

(defvar occhima/library-paths
  (list occhima/pdf-articles-dir
        occhima/pdf-books-dir))

(defvar occhima/org-roam-dir
  "~/Dropbox/projects/org/roam")


(after! bibtex
  (setq bibtex-completion-pdf-open-function
        (lambda (fpath)
          (call-process "open" nil 0 nil fpath))

        bibtex-completion-bibliography occhima/bibliographies
        bibtex-completion-library-path occhima/library-paths
        bibtex-completion-notes-path occhima/org-roam-dir
        bibtex-completion-additional-search-fields '(keywords)

        bibtex-completion-display-formats
        '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
          (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
          (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))))


(after! org-roam
  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section)
        org-roam-directory occhima/org-roam-dir))


(after! org-ref
  (require 'org-ref-arxiv)

  (setq bibtex-dialect 'biblatex
        org-ref-bibtex-pdf-download-dir occhima/pdf-articles-dir
        org-ref-show-equation-images-in-tooltips t)

  (defun occhima/arxiv-bulk-add-from-region (beg end)
    (interactive "r")
    (unless (use-region-p)
      (user-error "Select a region containing arXiv ids first"))
    (let ((text (buffer-substring-no-properties beg end))
          (ids nil)
          (start 0)
          (regexp "[0-9]\\{4\\}\\.[0-9]\\{5\\}"))
      (while (string-match regexp text start)
        (push (match-string 0 text) ids)
        (setq start (match-end 0)))
      (setq ids (nreverse ids))
      (unless ids
        (user-error "No arXiv ids found in region"))
      (unless (file-directory-p occhima/pdf-articles-dir)
        (make-directory occhima/pdf-articles-dir t))
      (dolist (id ids)
        (message "Adding arXiv:%s" id)
        (arxiv-get-pdf-add-bibtex-entry
         id
         occhima/bib-articles
         occhima/pdf-articles-dir)
        (sleep-for 1))))

  )


(after! citar
  (setq citar-bibliography occhima/bibliographies
        citar-library-paths occhima/library-paths
        citar-file-extensions '("pdf" "org" "md")
        citar-file-open-function #'find-file

        citar-templates
        '((main . "${author editor:55}     ${date year issued:4}     ${title:55}")
          (suffix . "  ${tags keywords keywords:40}")
          (preview . "${author editor} ${title}, ${journal publisher container-title collection-title booktitle} ${volume} (${year issued date}).\n")
          (note . "# Notes on ${author editor}, ${title}"))

        citar-open-note-function 'orb-citar-edit-note
        citar-notes-paths (list occhima/org-roam-dir))

  (advice-add #'completing-read-multiple
              :override #'consult-completing-read-multiple)

  (citar-capf-setup))


(after! scihub
  (setq scihub-download-directory occhima/pdf-articles-dir
        scihub-fetch-domain 'scihub-fetch-domains-lovescihub))


(after! org-cite
  (setq org-cite-global-bibliography occhima/bibliographies))
