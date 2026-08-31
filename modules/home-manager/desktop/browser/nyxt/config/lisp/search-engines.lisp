(in-package #:nyxt-user)

(defvar *extra-search-engines*
  (list
   (make-instance 'search-engine :name "Google" :shortcut "g"
                                 :control-url "https://google.com/search?q=~a"
                                 :control-completion-url
                                 "https://suggestqueries.google.com/complete/search?client=firefox&q=~a")
   (make-instance 'search-engine :name "MyNixos" :shortcut "mn"
                                 :control-url "https://mynixos.com/search?q=~a")
   (make-instance 'search-engine :name "Noogle" :shortcut "no"
                                 :control-url "https://noogle.dev/?q.txt=~a")
   (make-instance 'search-engine :name "Nixpkgs Issues" :shortcut "npi"
                                 :control-url "https://github.com/NixOS/nixpkgs/issues?q=~a")
   (make-instance 'search-engine :name "Home Manager Options" :shortcut "hm"
                                 :control-url "https://home-manager-options.extranix.com/?query=~a")
   (make-instance 'search-engine :name "GitHub" :shortcut "git"
                                 :control-url "https://github.com/search?q=~a")
   (make-instance 'search-engine :name "Google Scholar" :shortcut "gs"
                                 :control-url "https://scholar.google.com/scholar?q=~a")
   (make-instance 'search-engine :name "Reddit" :shortcut "r"
                                 :control-url "https://old.reddit.com/search?q=~a")
   (make-instance 'search-engine :name "YouTube" :shortcut "yt"
                                 :control-url "https://yewtu.be/search?q=~a")
   (make-instance 'search-engine :name "Arxiv" :shortcut "ax"
                                 :control-url "https://arxiv.org/search?query=~a&searchtype=all&source=header")
   (make-instance 'search-engine :name "Arch Linux AUR" :shortcut "arch"
                                 :control-url "https://aur.archlinux.org/packages?O=0&K=~a")
   (make-instance 'search-engine :name "Flathub" :shortcut "fl"
                                 :control-url "https://flathub.org/apps/search?q=~a"))
  "Search engines appended to Nyxt's defaults.")
