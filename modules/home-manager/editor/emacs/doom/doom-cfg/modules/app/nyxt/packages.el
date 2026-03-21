
(package! nyxt
  :recipe (:host github :repo "migalmoreno/nyxt.el" :files ("*.el")))

(package! emacs-with-nyxt
  :disable t
  :recipe (:host github :repo "ag91/emacs-with-nyxt" :files ("*.el")))
