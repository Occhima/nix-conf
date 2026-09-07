(in-package #:nyxt-user)

(defvar *palette-max-width* 900)
(defvar *palette-width-ratio* 0.62)
(defvar *palette-max-height* 440)
(defvar *palette-height-ratio* 0.52)
(defvar *palette-top-ratio* 0.16)

(defvar *palette-placement* (make-hash-table :test 'eq)
  "Window -> the prompt buffer already placed as a palette over it.

Presence is the whole answer: a palette is placed once, when it opens, and
closing it drops the entry so the next one places itself again.")

(defmethod (setf nyxt::ffi-height) :after ((height integer)
                                           (prompt-buffer prompt-buffer))
  "Float the prompt buffer as a centred command palette over the web view.

Nyxt resizes the prompt buffer as its suggestion list grows and shrinks, so
this runs on every keystroke of a prompt, and every Electron call below is a
synchronous round trip that the renderer is waiting on -- `%tile' alone is
one per pane, and reading the window's bounds is one more.  Doing that per
keystroke is what wedges the palette, so a palette that is already placed
does nothing at all here: its geometry follows the window's size, which does
not change while someone is typing into it."
  (ignore-errors
   (with-slots (window) prompt-buffer
     (cond
       ((not (plusp height))
        (remhash window *palette-placement*))
       ((eq prompt-buffer (gethash window *palette-placement*))
        nil)
       (t
        (let* ((bounds (uiop:symbol-call :electron :get-bounds window))
               (window-width (alexandria:assoc-value bounds :width))
               (window-height (alexandria:assoc-value bounds :height))
               (palette-width (min *palette-max-width*
                                   (round (* window-width *palette-width-ratio*))))
               (palette-height (min *palette-max-height*
                                    (round (* window-height *palette-height-ratio*)))))
          (uiop:symbol-call :electron :set-background-color
                            prompt-buffer "#00000000")
          (%tile window)
          (uiop:symbol-call :electron :set-bounds prompt-buffer
                            :x (round (/ (- window-width palette-width) 2))
                            :y (round (* window-height *palette-top-ratio*))
                            :width palette-width
                            :height palette-height)
          ;; Cached only once the calls above have actually succeeded --
          ;; caching it up front would leave a buffer that failed to place
          ;; stuck unstyled for its whole lifetime, since every later resize
          ;; would then see it as "already placed" and skip retrying.
          (setf (gethash window *palette-placement*) prompt-buffer)))))))

(define-configuration predicted-command-source
  ((prompter:constructor
    (lambda (source)
      (declare (ignore source))
      (alexandria:when-let ((command (nyxt::predict-next-command *browser*)))
        (list command))))))

(define-configuration prompt-buffer
  ((style
    (str:concat
     %slot-value%
     "@keyframes nyxt-palette-in {
        from { opacity: 0; transform: translateY(-8px) scale(0.985); }
        to   { opacity: 1; transform: none; } }"
     (theme:themed-css (theme *browser*)
       '("html, body"
         :height "100%"
         :margin "0"
         :padding "0"
         :background "transparent"
         :box-sizing "border-box")
       `(body
         :color ,theme:on-background-color
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "13px"
         :letter-spacing "0.01em")
       `("#root"
         :height "100%"
         :box-sizing "border-box"
         :display "grid"
         :grid-template-rows "auto 1fr"
         :row-gap "6px"
         :padding "10px 0 6px 0"
         :border-radius "6px"
         :background-color ,theme:background-color
         :border ,(format nil "1px solid ~a"
                          (%hairline theme:on-background-color 0.12))
         :box-shadow "0 8px 24px rgba(0,0,0,0.35)"
         :animation "nyxt-palette-in 150ms cubic-bezier(0.2, 0.7, 0.3, 1) both")
       `("#prompt-area"
         :margin "0 0 4px 0"
         :height "34px"
         :align-items "center"
         :border "none"
         :border-radius "0"
         :background-color "transparent"
         :box-shadow ,(format nil "inset 0 -1px 0 0 ~a"
                              (%hairline theme:on-background-color 0.10)))
       `("#prompt"
         :background-color "transparent"
         :color ,theme:primary-color
         :font-size "10px"
         :letter-spacing "0.10em"
         :text-transform "uppercase"
         :line-height "34px"
         :padding "0 2px 0 14px"
         :max-width "24ch")
       '("#prompt-input"
         :line-height "34px"
         :padding "0 6px"
         :min-width "12ch")
       `("#prompt-extra"
         :background-color "transparent"
         :color ,theme:primary-color
         :font-size "10px"
         :line-height "34px"
         :padding-right "14px")
       '("#prompt-modes, #close-button"
         :display "none")
       '("#previous-source, #next-source, #toggle-attributes"
         :display "none")
       `(input
         :font-family ,(%mono-stack theme:monospace-font-family))
       `("#input"
         :height "34px"
         :border "none"
         :border-radius "0"
         :padding "0"
         :background-color "transparent"
         :color ,theme:on-background-color
         :font-size "14px"
         :box-shadow "none"
         :outline "none")
       '("#input:focus"
         :box-shadow "none")
       '("#suggestions"
         :margin "0"
         :min-height "0"
         :overflow-y "auto"
         :overflow-x "hidden")
       '(".source"
         :margin "0 0 14px 0")
       '(".source:last-of-type"
         :margin-bottom "0")
       `(".source-name"
         :background-color "transparent"
         :color ,theme:primary-color
         :font-size "10px"
         :letter-spacing "0.10em"
         :text-transform "uppercase"
         :border-radius "0"
         :border "none"
         :padding "0 0 6px 14px")
       '(".source-name > div"
         :line-height "14px")
       '(".source-content th"
         :display "none")
       `(".source-content"
         :padding-left "0"
         :margin-left "0"
         :border-spacing "0 2px"
         :table-layout "auto"
         (td
          :height "24px"
          :padding "0 14px 0 0"
          :border-radius "0"
          :color ,theme:primary-color
          :overflow "hidden"
          :text-overflow "ellipsis"
          :white-space "nowrap")
         ("td:first-child"
          :color ,theme:on-background-color
          :width "1%"
          :padding-left "14px"
          :white-space "nowrap")
         ("tr:hover td"
          :background-color ,(%hairline theme:on-background-color 0.07)))
       '(".source-content col"
         :width "auto !important")
       `("#selection"
         :background-color ,theme:secondary-color)
       `("#selection td"
         :background-color ,theme:secondary-color
         :color ,theme:on-background-color)
       `(.marked
         :background-color "transparent"
         :color ,theme:on-background-color)
       `(.selected
         :background-color "transparent"
         :color ,theme:on-background-color)
       '("::-webkit-scrollbar"
         :width "6px")
       '("::-webkit-scrollbar-track"
         :background "transparent")
       `("::-webkit-scrollbar-thumb"
         :background-color ,(%hairline theme:on-background-color 0.18)
         :border-radius "6px"))))))
