;;; packages.el -*- no-byte-compile: t; -*-

(package! acp :recipe (:host github :repo "xenodium/acp.el"))
(package! agent-recall)
(package! agent-shell)
(package! agent-shell-bookmark
  :recipe (:host github :repo "dcluna/agent-shell-bookmark")
  :pin "c1eab34bff4f35bf929885ed5045c6100afcf496")
(package! agent-shell-sidebar
  :recipe (:host github :repo "cmacrae/agent-shell-sidebar")
  :pin "10fee0b1463cdf210b0908c23e940a44c8d4a8e2")
(package! agent-shell-workspace
  :recipe (:host github :repo "gveres/agent-shell-workspace")
  :pin "b72ccdb0b602d9a8ecd94f16aa3456155ba0b2e9")
(package! biome)
(package! blamer)
(package! calibredb :recipe (:host github :repo "chenyanming/calibredb.el"))
(package! casual)
(package! llama)
(package! combobulate
  :recipe (:host github :repo "mickeynp/combobulate")
  :pin "f7ea37b7ed5a463781a4b7122e4563f1c0fdc90f")
(package! corg :recipe (:host github :repo "isamert/corg.el"))
(package! consult-gh
  :recipe (:host github
           :repo "armindarvish/consult-gh"
           :files ("*.el")))
(package! consult-omni
  :recipe (:host github :repo "armindarvish/consult-omni"
           :files (:defaults "sources/*.el"))
  :pin "3a126ee54479755408faed10da945dbc2366303b")
(package! consult-mu
  :recipe (:host github :repo "armindarvish/consult-mu")
  :pin "8b54bbf86c2f112e3520eeeefb70d509b4590385")
(package! dashboard)
(package! devdocs)
(package! eat :built-in 'prefer)
(package! eldoc-box)
(package! ess-plot
  :recipe (:host github :repo "DennieTeMolder/ess-plot")
  :pin "bb10c3456b1441ae30a59bfe5b7517dbf97089a6")
(package! ecss :recipe (:host github :repo "emacs-taf/ecss")
  :pin "bfb553ae87c2cb2d385d825592c758cf77d39f44")
(package! ebox :recipe (:host github :repo "emacs-taf/ebox")
  :pin "cfdb826e1d98980e3a0cc701586f3821aab3f2d0")
(package! etaf :recipe (:host github :repo "emacs-taf/etaf")
  :pin "2395f838f15648d863dd33e45b52329899ab2fc0")
(package! exc :recipe (:host github :repo "yibie/exc.el" :files (:defaults "plugins/*"))
  :pin "379671e3241b052aa8b1a4ff52d4207f5f0dd2ed")
(package! flyover :recipe (:host github :repo "konrad1977/flyover"))
(package! goggles :recipe (:host github :repo "minad/goggles"))
(package! gumshoe :recipe (:host github :repo "Overdr0ne/gumshoe"))
(package! jinx :recipe (:host github :repo "minad/jinx"))
(package! just-mode)
(package! justl :recipe (:host github :repo "psibi/justl.el"))
(package! nov)
(package! org-ref)
(package! org-super-agenda)
(package! osm :recipe (:host github :repo "minad/osm"))
(package! pdf-tools :built-in 'prefer)
(package! scihub :recipe (:host github :repo "emacs-pe/scihub.el"))
(package! shell-maker)
(package! tempel :recipe (:host github :repo "minad/tempel"))
(package! tempel-collection :recipe (:host github :repo "Crandel/tempel-collection"))
