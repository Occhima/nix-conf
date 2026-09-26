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

(setq! citar-bibliography occhima/bibliographies
       citar-library-paths occhima/library-paths
       citar-notes-paths (list occhima/org-roam-dir)
       citar-file-extensions '("pdf" "org" "md")
       citar-file-open-function #'find-file
       bibtex-completion-bibliography occhima/bibliographies
       bibtex-completion-library-path occhima/library-paths
       bibtex-completion-notes-path occhima/org-roam-dir
       org-cite-global-bibliography occhima/bibliographies)

(after! citar
  (setq citar-templates
        '((main . "${author editor:55}     ${date year issued:4}     ${title:55}")
          (suffix . "  ${tags keywords keywords:40}")
          (preview . "${author editor} ${title}, ${journal publisher container-title collection-title booktitle} ${volume} (${year issued date}).\n")
          (note . "# Notes on ${author editor}, ${title}"))))

(after! org-ref
  (require 'org-ref-arxiv)
  (setq bibtex-dialect 'biblatex
        org-ref-bibtex-pdf-download-dir occhima/pdf-articles-dir
        org-ref-show-equation-images-in-tooltips t)
  )

(after! scihub
  (setq scihub-download-directory occhima/pdf-articles-dir
        scihub-fetch-domain 'scihub-fetch-domains-lovescihub))


(defun occhima/nyxt-arxiv-add (id)
  "Add arXiv ID to the article library. Entry point for Nyxt's `add-paper'."
  (require 'org-ref-arxiv)
  (make-directory occhima/pdf-articles-dir t)
  (arxiv-get-pdf-add-bibtex-entry
   id (car occhima/bibliographies) occhima/pdf-articles-dir)
  (message "Added arXiv:%s" id))

(defvar occhima/nyxt--quote ""
  "Selected text of the page being captured, read by `occhima/nyxt--quote-block'.")

(defun occhima/nyxt--quote-block ()
  (if (string-empty-p occhima/nyxt--quote)
      ""
    (format "#+begin_quote\n%s\n#+end_quote\n\n" occhima/nyxt--quote)))

(defun occhima/nyxt--with-quote (template)
  "TEMPLATE with the captured quote prepended to its body, when it has one."
  (if (stringp (nth 3 template))
      (append (seq-take template 3)
              (list (concat "%(occhima/nyxt--quote-block)" (nth 3 template)))
              (nthcdr 4 template))
    template))

(defun occhima/nyxt-roam-capture (url title &optional quote)
  "Capture URL with TITLE as an org-roam ref node, QUOTE as its first block."
  (require 'org-roam)
  (setq occhima/nyxt--quote (or quote ""))
  (org-roam-capture- :node (org-roam-node-create :title title)
                     :info (list :ref url)
                     :templates (mapcar #'occhima/nyxt--with-quote
                                        (or (bound-and-true-p org-roam-capture-ref-templates)
                                            org-roam-capture-templates))))

(defvar occhima/nyxt-read-later-file "~/Dropbox/DropsyncFiles/todo.org")

(defun occhima/nyxt-read-later (url title)
  "File URL under \"Read later\" in `occhima/nyxt-read-later-file', scheduled for Friday."
  (require 'org)
  (with-current-buffer (find-file-noselect occhima/nyxt-read-later-file)
    (org-with-wide-buffer
     (unless (org-find-exact-headline-in-buffer "Read later")
       (goto-char (point-max))
       (insert "\n* Read later\n"))
     (goto-char (org-find-exact-headline-in-buffer "Read later"))
     (org-end-of-subtree t t)
     (unless (bolp) (insert "\n"))
     (insert (format "** TODO %s\nSCHEDULED: %s\n"
                     (org-link-make-string url title)
                     (format-time-string "<%Y-%m-%d %a>" (org-read-date nil t "fri")))))
    (save-buffer))
  (message "Read later: %s" title))

(defun occhima/nyxt-doi-add (doi)
  "Add DOI to the article library."
  (require 'org-ref)
  (require 'doi-utils)
  (doi-utils-add-bibtex-entry-from-doi doi (car occhima/bibliographies))
  (message "Added doi:%s" doi))

(defun occhima/nyxt-roam-import (file url title)
  "Turn FILE, an Org article Nyxt converted, into an org-roam node for URL."
  (require 'org-roam)
  (let ((path (expand-file-name
               (format "%s-%s.org"
                       (format-time-string "%Y%m%d%H%M%S")
                       (org-roam-node-slug (org-roam-node-create :title title)))
               org-roam-directory)))
    (with-temp-file path
      (insert (format ":PROPERTIES:\n:ID: %s\n:ROAM_REFS: %s\n:END:\n#+title: %s\n\n"
                      (org-id-new) url title))
      (insert-file-contents file))
    (delete-file file)
    (org-roam-db-update-file path)
    (find-file path)))

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
      (sleep-for 1))))
