;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(unpin! org-gcal)
(unpin! julia-snail)
(unpin! eglot)
(unpin! doom-modeline)
(unpin! docker)
(unpin! jupyter)

(package! org-super-agenda)
(package! hackernews)
(package! org-modern)
(package! sx)
(package! telega)
(package! ement)

(package! org-ref)

(package! org-timeblock :recipe (:host github :repo "ichernyshovvv/org-timeblock"))

(package! jinx :recipe (:host github :repo "minad/jinx"))
(package! goggles :recipe (:host github :repo "minad/goggles"))
(package! tempel :recipe (:host github :repo "minad/tempel"))
(package! tempel-collection :recipe (:host github :repo "Crandel/tempel-collection"))

(package! eldoc-box)

(package! mastodon)

(package! empv :recipe (:host github :repo "isamert/empv.el"))

(package! casual-suite)

(package! gumshoe :recipe (:host github :repo "Overdr0ne/gumshoe"))

(package! smudge)

(package! combobulate :recipe (:host github :repo "mickeynp/combobulate"))

(package! ess-plot :recipe (:host github :repo "DennieTeMolder/ess-plot"))
(package! scihub :recipe (:host github :repo "emacs-pe/scihub.el"))
(package! corg :recipe (:host github :repo "isamert/corg.el"))
(package! flyover :recipe (:host github :repo "konrad1977/flyover"))

(provide 'packages)
