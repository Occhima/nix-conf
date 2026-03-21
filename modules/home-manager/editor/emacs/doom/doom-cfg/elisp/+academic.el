
(after! bibtex
  (setq bibtex-completion-pdf-open-function (lambda (fpath)
                                              (call-process "open" nil 0 nil fpath))
        bibtex-completion-bibliography '(
                                         "~/Dropbox/projects/library/bibliography/articles.bib"
                                         "~/Dropbox/projects/library/bibliography/books.bib"
                                         "~/Dropbox/projects/library/bibliography/misc.bib"
                                         )
        bibtex-completion-library-path '(
                                         "~/Dropbox/projects/library/articles/"
                                         "~/Dropbox/projects/library/books/"
                                         )
        bibtex-completion-notes-path "~/Dropbox/projects/org/roam"
        bibtex-completion-additional-search-fields '(keywords)
        bibtex-completion-display-formats
        '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
          (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
          (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
        )

  )

(after! org-roam
  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section)
        org-roam-directory  "~/Dropbox/projects/org/roam"
        )
  )


(after! org-ref
  (setq bibtex-dialect 'biblatex
        org-ref-bibtex-pdf-download-dir "~/Dropbox/projects/library/articles"
        org-ref-show-equation-images-in-tooltips t
        )
  )

(after! citar
  (setq citar-bibliography  '(
                              "~/Dropbox/projects/library/bibliography/articles.bib"
                              "~/Dropbox/projects/library/bibliography/books.bib"
                              "~/Dropbox/projects/library/bibliography/misc.bib"
                              )
        citar-library-paths  '(
                               "~/Dropbox/projects/library/articles/"
                               "~/Dropbox/projects/library/books/"
                               )
        citar-file-extensions '("pdf" "org" "md")
        citar-file-open-function #'find-file
        citar-templates
        '((main . "${author editor:55}     ${date year issued:4}     ${title:55}")
          (suffix . "  ${tags keywords keywords:40}")
          (preview . "${author editor} ${title}, ${journal publisher container-title collection-title booktitle} ${volume} (${year issued date}).\n")

          (note . "# Notes on ${author editor}, ${title}"))
        citar-open-note-function 'orb-citar-edit-note
        citar-notes-paths '("~/Dropbox/projects/org/roam" ))
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)
  (citar-capf-setup)
  )


(after! scihub
  (setq scihub-download-directory "~/Dropbox/projects/library/articles/"
        scihub-fetch-domain 'scihub-fetch-domains-lovescihub
        )
  )

(after! org-cite
  (setq
   org-cite-global-bibliography '(
                                  "~/Dropbox/projects/library/bibliography/articles.bib"
                                  "~/Dropbox/projects/library/bibliography/books.bib"
                                  "~/Dropbox/projects/library/bibliography/misc.bib"
                                  )

   )
  )
