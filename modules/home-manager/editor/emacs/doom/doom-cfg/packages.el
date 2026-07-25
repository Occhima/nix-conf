;;; packages.el -*- no-byte-compile: t; -*-

(package! acp :recipe (:host github :repo "xenodium/acp.el"))
(package! agent-recall)
(package! agent-shell)
(package! agent-shell-bookmark :recipe (:host github :repo "dcluna/agent-shell-bookmark"))
(package! agent-shell-sidebar :recipe (:host github :repo "cmacrae/agent-shell-sidebar"))
(package! agent-shell-workspace :recipe (:host github :repo "gveres/agent-shell-workspace"))
(package! biome)
(package! blamer)
(package! calibredb :recipe (:host github :repo "chenyanming/calibredb.el"))
(package! claude-code
  :recipe (:host github
           :repo "stevemolitor/claude-code.el"
           :branch "main"
           :depth 1
           :files ("*.el" (:exclude "images/*"))))
(package! combobulate :recipe (:host github :repo "mickeynp/combobulate"))
(package! corg :recipe (:host github :repo "isamert/corg.el"))
(package! devdocs)
(package! eat :built-in 'prefer)
(package! eldoc-box)
(package! ess-plot :recipe (:host github :repo "DennieTeMolder/ess-plot"))
(package! flyover :recipe (:host github :repo "konrad1977/flyover"))
(package! goggles :recipe (:host github :repo "minad/goggles"))
(package! gumshoe :recipe (:host github :repo "Overdr0ne/gumshoe"))
(package! jinx :recipe (:host github :repo "minad/jinx"))
(package! just-mode)
(package! justl :recipe (:host github :repo "psibi/justl.el"))
(package! monet :recipe (:host github :repo "stevemolitor/monet"))
(package! nov)
(package! org-ref)
(package! org-super-agenda)
(package! osm :recipe (:host github :repo "minad/osm"))
(package! pdf-tools :built-in 'prefer)
(package! scihub :recipe (:host github :repo "emacs-pe/scihub.el"))
(package! shell-maker)
(package! tempel :recipe (:host github :repo "minad/tempel"))
(package! tempel-collection :recipe (:host github :repo "Crandel/tempel-collection"))
