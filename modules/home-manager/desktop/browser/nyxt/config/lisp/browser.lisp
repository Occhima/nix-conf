(in-package #:nyxt-user)

(defun %host-command (command)
  "COMMAND, routed through the Flatpak host when Nyxt runs inside a sandbox."
  (if (member :flatpak *features*)
      (str:concat "flatpak-spawn --host " command)
      command))

(define-configuration browser
  ((external-editor-program (%host-command "emacsclient -c"))
   (search-engines (append %slot-default% *extra-search-engines*))
   (search-engine-suggestions-p nil)
   (default-new-buffer-url (quri:uri (nyxt-url 'start-page)))
   (nyxt/renderer/electron:adblocking-enabled-p nil)))

(define-configuration nyxt/mode/hint:hint-mode
  ((nyxt/mode/hint:hints-alphabet "DSJKHLFAGNMXCWEIO")
   (nyxt/mode/hint:hints-selector
    "a, button, input, textarea, details, select, [role=button], [role=link], [onclick], summary")))

(define-configuration document-buffer
  ((smooth-scrolling t)))

(defmethod nyxt:style :around ((mode nyxt/mode/hint:hint-mode))
  (str:concat
   (call-next-method)
   (theme:themed-css (theme *browser*)
     `(".nyxt-hint"
       :background-color ,theme:background-color+
       :color ,theme:on-background-color
       :font-size "11px"
       :font-weight "600"
       :letter-spacing "0.06em"
       :padding "1px 5px"
       :border "none"
       :border-radius "4px"
       :box-shadow ,(format nil "0 0 0 1px ~a, 0 2px 6px rgba(0,0,0,0.35)"
                            (%hairline theme:action-color 0.55)))
     `(".nyxt-hint.nyxt-current-hint"
       :background-color ,theme:action-color
       :color ,theme:on-action-color)
     `(".nyxt-hint.nyxt-mark-hint"
       :background-color ,theme:highlight-color
       :color ,theme:on-highlight-color)
     `(".nyxt-element-hint"
       :background-color ,(%hairline theme:action-color 0.25)))))
