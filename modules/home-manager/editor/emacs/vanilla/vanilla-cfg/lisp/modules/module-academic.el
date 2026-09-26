;;; module-academic.el --- Bibliography and research notes -*- lexical-binding: t; -*-

(require 'core-evil)

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

(use-package oc
  :ensure nil
  :after org
  :custom
  (org-cite-global-bibliography occhima/bibliographies)
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar))

(use-package citar-embark
  :after (citar embark)
  :config
  (citar-embark-mode 1))

(use-package citar-org-roam
  :after (citar org-roam)
  :config
  (citar-org-roam-mode 1))

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

(setq browse-url-browser-function #'browse-url-generic
      browse-url-generic-program "nyxt")

(defvar occhima/nyxt-slynk-port 4008
  "Port that Nyxt's `start-slynk' command listens on.")

;; Nix provides sly so it matches the slynk version Nyxt loads.
(use-package sly
  :ensure nil
  :commands (sly sly-connect)
  :config
  (setq sly-contribs (delq 'sly-quicklisp sly-contribs)))

(defun occhima/nyxt-connect ()
  "Connect SLY to Nyxt's Slynk server; run `start-slynk' in Nyxt first."
  (interactive)
  (sly-connect "127.0.0.1" occhima/nyxt-slynk-port))

(defun occhima/nyxt-eval (form)
  "Evaluate FORM, a Common Lisp source string, inside the connected Nyxt."
  (require 'sly)
  (unless (sly-connected-p)
    (occhima/nyxt-connect))
  (sly-eval `(slynk:interactive-eval-region ,form)))

(occhima/leader
  "o n" '(occhima/nyxt-connect :wk "Connect to Nyxt"))

(defun occhima/nyxt-arxiv-add (id)
  "Add arXiv ID to the article library. Entry point for Nyxt's `add-paper'."
  (require 'org-ref-arxiv)
  (make-directory occhima/pdf-articles-directory t)
  (arxiv-get-pdf-add-bibtex-entry
   id (car occhima/bibliographies) occhima/pdf-articles-directory)
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

(use-package scihub
  :ensure (scihub :host github :repo "emacs-pe/scihub.el")
  :custom
  (scihub-download-directory occhima/pdf-articles-directory)
  (scihub-fetch-domain 'scihub-fetch-domains-lovescihub))

(provide 'module-academic)
;;; module-academic.el ends here
