;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)
;;; Packages:
;;;


;;; Code:
(unpin! org-gcal)
(unpin! julia-snail)
(unpin! eglot)
;;(unpin! evil-collection)
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



(package! dashboard
  :disable t
  )
(package! all-the-icons
  :disable t
  )

(package! jinx :recipe (:host github :repo "minad/jinx"))
(package! goggles :recipe (:host github :repo "minad/goggles"))
(package! tempel :recipe (:host github :repo "minad/tempel"))
(package! tempel-collection :recipe (:host github :repo "Crandel/tempel-collection"))  ;; py-pyment dependency!

(package! eldoc-box)


(package! mastodon)
(package! srcery-theme
  :disable t
  )


(package! empv
  :recipe (:host github :repo "isamert/empv.el"))


(package! golden-ratio
  :disable t
  :recipe (:host github :repo "roman/golden-ratio.el"))

(package! elfeed-tube
  :disable t
  )

;; (package! casual)


(package! casual-suite)


(package! combobulate
  :disable t
  :recipe (:host github
           :repo "mickeynp/combobulate"
           )
  )

;; (package! eglot-booster
;;   :disa
;;   :recipe (:host github
;;            :repo "jdtsmith/eglot-booster"
;;            )
;;   )


(package! gumshoe
  :recipe (:host github
           :repo "Overdr0ne/gumshoe"
           )
  )

(package! smudge
  ;; :disable t
  )

(package! ess-plot
  :recipe (:host github :repo "DennieTeMolder/ess-plot"))
(package! scihub :recipe (:host github :repo "emacs-pe/scihub.el"))
(package! corg :recipe (:host github :repo "isamert/corg.el"))
(package! flyover :recipe (:host github :repo "konrad1977/flyover"))


(provide 'packages)
