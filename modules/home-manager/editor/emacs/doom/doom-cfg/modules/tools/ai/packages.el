(package! shell-maker)
(package! acp
  :recipe (:host github :repo "xenodium/acp.el"))
(package! agent-shell)

(package! agent-shell-bookmark
  :recipe (:host github :repo "dcluna/agent-shell-bookmark"))

(package! agent-recall)

(package! agent-shell-workspace
  :recipe (:host github :repo "gveres/agent-shell-workspace"))

(package! agent-shell-sidebar
  :recipe (:host github :repo "cmacrae/agent-shell-sidebar"))


(package! chatgpt-shell
  :disable t
  :recipe  (:host github :repo "xenodium/chatgpt-shell")
  )

(package! gptel
  :disable t
  )

(package! aidermacs
  :disable t
  :recipe
  (:host github :repo "MatthewZMD/aidermacs" :files ("*.el")))


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
