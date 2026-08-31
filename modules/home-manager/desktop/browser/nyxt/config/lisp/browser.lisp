(in-package #:nyxt-user)

(defun %host-command (command)
  "COMMAND, routed through the Flatpak host when Nyxt runs inside a sandbox."
  (if (member :flatpak *features*)
      (str:concat "flatpak-spawn --host " command)
      command))

(define-configuration browser
  ((external-editor-program (%host-command "emacsclient -c"))
   (search-engines (append %slot-default% *extra-search-engines*))
   (search-engine-suggestions-p t)
   (default-new-buffer-url (quri:uri (nyxt-url 'start-page)))
   (nyxt/renderer/electron:adblocking-enabled-p nil)))

(define-configuration nyxt/mode/hint:hint-mode
  ((nyxt/mode/hint:hints-alphabet "DSJKHLFAGNMXCWEIO")
   (nyxt/mode/hint:hints-selector
    "a, button, input, textarea, details, select, [role=button], [role=link], [onclick], summary")))
