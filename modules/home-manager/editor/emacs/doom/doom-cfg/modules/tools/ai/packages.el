
(package! chatgpt-shell
  :recipe  (:host github :repo "xenodium/chatgpt-shell")
  )

(package! gptel
  :disable t
  )

(package! aidermacs :recipe (:host github :repo "MatthewZMD/aidermacs" :files ("*.el")))


(package! copilot
  :disable t
  :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))

(package! khoj
  :disable t
  )

(package! monet
  :recipe (:host github :repo "stevemolitor/monet"))

(package! claude-code
  :recipe (:host github :repo "stevemolitor/claude-code.el" :branch "main" :depth 1
           :files ("*.el" (:exclude "images/*"))))
