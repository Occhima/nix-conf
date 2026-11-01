(in-package #:nyxt-user)

(defvar *palette-max-width* 900)
(defvar *palette-width-ratio* 0.62)
(defvar *palette-max-height* 440)
(defvar *palette-height-ratio* 0.52)
(defvar *palette-top-ratio* 0.16)

(defvar *palette-lock* (sb-thread:make-mutex :name "palette-views"))

(defvar *palette-views* (make-hash-table :test 'eq)
  "Window -> native ids of every prompt view floated over it.")

(defvar *palette-free* (make-hash-table :test 'eq)
  "Window -> native ids of prompt views that no open prompt is using.

Creating a CEF browser per prompt is what made every C-l wait on the renderer,
up to CEF's 5s browser-info timeout.  A closed prompt hands its view back here
and the next prompt adopts it.")

(defmethod cef:reuse-native-id ((prompt-buffer prompt-buffer))
  (sb-thread:with-mutex (*palette-lock*)
    (pop (gethash (window prompt-buffer) *palette-free*))))

(defmethod cef:retain-native-p ((prompt-buffer prompt-buffer))
  t)

(defun %palette-place (prompt-buffer)
  "Show PROMPT-BUFFER centred over its window, hiding the other prompts there."
  (let* ((window (window prompt-buffer))
         (bounds (cef:get-content-bounds window))
         (window-width (alexandria:assoc-value bounds :width))
         (window-height (alexandria:assoc-value bounds :height))
         (width (min *palette-max-width* (round (* window-width *palette-width-ratio*))))
         (height (min *palette-max-height* (round (* window-height *palette-height-ratio*)))))
    (dolist (other (nyxt::active-prompt-buffers window))
      (unless (eq other prompt-buffer)
        (cef:set-overlay other nil)))
    (cef:set-overlay prompt-buffer t
                     :x (round (- window-width width) 2)
                     :y (round (* window-height *palette-top-ratio*))
                     :width width
                     :height height)))

(handler-bind ((sb-kernel:redefinition-with-defmethod #'muffle-warning))
  (defmethod (setf ffi-height) ((height integer) (prompt-buffer prompt-buffer))
    "Float the prompt as a centred palette instead of a bar under the page."
    (let* ((window (window prompt-buffer))
           (id (cef:id prompt-buffer))
           (fresh (sb-thread:with-mutex (*palette-lock*)
                    (unless (member id (gethash window *palette-views*))
                      (push id (gethash window *palette-views*))))))
      (setf (nyxt/renderer/cef::set-height prompt-buffer) height)
      (if fresh
          (cef:add-overlay-view window prompt-buffer)
          (when (plusp height)
            (nyxt::prompt-render-skeleton prompt-buffer)))
      (if (plusp height)
          (%palette-place prompt-buffer)
          (cef:set-overlay prompt-buffer nil))
      (when fresh
        (nyxt::prompt-render-skeleton prompt-buffer)
        (nyxt::prompt-render-focus prompt-buffer)))))

(defmethod ffi-buffer-delete ((prompt-buffer prompt-buffer))
  "Hide the palette and keep its view for the next prompt."
  (let ((window (window prompt-buffer))
        (id (cef:id prompt-buffer)))
    (when (cef:web-contents prompt-buffer)
      (cef:set-overlay prompt-buffer nil)
      (cef:kill prompt-buffer)
      (sb-thread:with-mutex (*palette-lock*)
        (push id (gethash window *palette-free*))))
    (setf (nyxt/renderer/cef::listeners-p prompt-buffer) nil)))

(define-configuration prompt-buffer
  ((style
    (str:concat
     %slot-value%
     "@keyframes nyxt-palette-in {
        from { opacity: 0; transform: translateY(-10px) scale(0.98); }
        to   { opacity: 1; transform: none; } }"
     (theme:themed-css (theme *browser*)
       `("html, body"
         :height "100%"
         :margin "0"
         :padding "0"
         :background ,theme:background-color
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
         :background-color ,theme:background-color
         :border ,(format nil "1px solid ~a"
                          (%hairline theme:on-background-color 0.18))
         :animation "nyxt-palette-in 160ms cubic-bezier(0.2, 0.7, 0.3, 1) both")
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
         :outline "none"
         :caret-color ,theme:action-color)
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

(defmethod ffi-buffer-evaluate-javascript :around ((prompt-buffer prompt-buffer) javascript
                                                   &optional world-name)
  "Drop renders that land after the prompt has closed and handed its view back."
  (declare (ignore javascript world-name))
  (when (cef:web-contents prompt-buffer)
    (call-next-method)))

(defmethod ffi-buffer-evaluate-javascript-async :around ((prompt-buffer prompt-buffer) javascript
                                                         &optional world-name)
  (declare (ignore javascript world-name))
  (when (cef:web-contents prompt-buffer)
    (call-next-method)))
