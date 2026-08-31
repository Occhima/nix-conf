(in-package #:nyxt-user)

(defun %supersede-status-method (name)
  "Drop the built-in method on `status-buffer' for the generic function NAME.

The Electron renderer dispatches on `(type-of buffer)' against a literal list of
class names, so a `status-buffer' subclass is never recognised and the methods
below have to land on `status-buffer' itself.  Removing the shipped method first
means each one is a fresh definition rather than a redefinition."
  (let ((gf (fdefinition name)))
    (alexandria:when-let
        ((method (find-method gf '() (list (find-class 'status-buffer)) nil)))
      (remove-method gf method))))

(mapc #'%supersede-status-method
      '(format-status-load-status
        format-status-url
        format-status-tabs
        format-status-modes))

(defun %status-target (status)
  "Active buffer of STATUS's window, or NIL while the window is being built."
  (alexandria:when-let ((window (window status)))
    (active-buffer window)))

(defmethod format-status :around ((status status-buffer))
  (if (window status) (call-next-method) ""))

(defmethod format-status-load-status ((status status-buffer))
  "Spinning indicator while the active buffer loads."
  (alexandria:when-let ((buffer (%status-target status)))
    (spinneret:with-html
      (when (and (web-buffer-p buffer)
                 (eq (nyxt::status buffer) :loading))
        (:span :class "spinner")))))

(defun %status-url-parts (url)
  "Return (VALUES ICON-GLYPH ICON-CLASS HOST TAIL) describing URL."
  (let ((tail (str:concat (or (quri:uri-path url) "")
                          (if (quri:uri-query url)
                              (str:concat "?" (quri:uri-query url))
                              ""))))
    (cond
      ((internal-url-p url)
       (values (format nil "~a:" (quri:uri-scheme url)) "url-scheme"
               (string-left-trim "/" (or (quri:uri-path url) "")) ""))
      ((quri:uri-https-p url)
       (values "" "url-scheme"
               (or (quri:uri-host url) "")
               (if (string= tail "/") "" tail)))
      ((quri:uri-http-p url)
       (values "http://" "url-scheme insecure"
               (or (quri:uri-host url) "")
               (if (string= tail "/") "" tail)))
      (t
       (values "" "url-scheme" (render-url url) "")))))

(defmethod format-status-url ((status status-buffer))
  "URL pill: scheme indicator, emphasised host, de-emphasised path."
  (alexandria:when-let* ((buffer (%status-target status))
                         (url (url buffer)))
    (multiple-value-bind (glyph class host tail) (%status-url-parts url)
      (spinneret:with-html
        (:button.button
         :title (title buffer)
         :onclick (ps:ps
                    (nyxt/ps:lisp-eval
                     (:title "set-url" :buffer status)
                     (nyxt:set-url)))
         (unless (str:emptyp glyph)
           (:span :class class glyph))
         (:span :class "url-host" host)
         (unless (str:emptyp tail)
           (:span :class "url-tail" tail)))))))

(defmethod format-status-tabs ((status status-buffer))
  "Tab strip with per-tab close affordance.

Suppressed while a single buffer is open, where every tab would only repeat what
the URL already says."
  (let* ((buffers (reverse (buffer-list)))
         (current-buffer (%status-target status)))
    (when (rest buffers)
      (spinneret:with-html
      (loop for buffer in buffers
            collect
            (let* ((buffer buffer)
                   (url (url buffer))
                   (label (if (internal-url-p url)
                              (format nil "~a:~a"
                                      (quri:uri-scheme url) (quri:uri-path url))
                              (or (quri:uri-domain url) (render-url url)))))
              (:span
               :class (if (eq current-buffer buffer) "selected-tab tab" "tab")
               :title (title buffer)
               :onclick (ps:ps
                          (nyxt/ps:lisp-eval
                           (:title "select-tab" :buffer status)
                           (set-current-buffer buffer)))
               (:span :class "tab-label" label)
               (:span :class "tab-close"
                      :title "Close tab"
                      :onclick (ps:ps
                                 (ps:chain event (stop-propagation))
                                 (nyxt/ps:lisp-eval
                                  (:title "close-tab" :buffer status)
                                  (nyxt:delete-buffer :buffers (list buffer))))
                      *glyph-close*))))))))

(defmethod format-status-modes ((status status-buffer))
  "Single toggle glyph; the mode list itself lives behind it."
  (alexandria:when-let ((buffer (%status-target status)))
    (spinneret:with-html
      (:nbutton :buffer status :text *glyph-modes*
        :title (nyxt::modes-string buffer)
        '(nyxt:toggle-modes)))))

(define-configuration status-buffer
  ((glyph-mode-presentation-p nil)
   (height 28)
   (style
    (str:concat
     %slot-value%
     "@keyframes nyxt-spin { to { transform: rotate(360deg); } }"
     (theme:themed-css (theme *browser*)
       `(body
         :background-color ,theme:background-color
         :color ,theme:primary-color
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "12px"
         :line-height "normal"
         :letter-spacing "0.01em"
         :overflow "hidden"
         :border-top ,(format nil "1px solid ~a"
                              (%hairline theme:on-background-color 0.10)))
       '("::-webkit-scrollbar"
         :display "none")
       '("#container"
         :display "flex"
         :align-items "center"
         :gap "12px"
         :height "28px"
         :padding "0 12px"
         :box-sizing "border-box")
       '("#controls"
         :display "none")
       `("#url"
         :flex "1 1 auto"
         :min-width "0"
         :display "flex"
         :align-items "center"
         :gap "9px"
         :height "28px"
         :line-height "normal"
         :margin "0"
         :padding "0"
         :border "none"
         :border-radius "0"
         :background-color "transparent"
         :overflow "hidden")
       '("#url button"
         :display "flex"
         :align-items "center"
         :gap "6px"
         :width "100%"
         :height "28px"
         :overflow "hidden")
       `(".url-scheme"
         :flex "0 0 auto"
         :color ,theme:primary-color)
       `(".url-scheme.insecure"
         :color ,theme:warning-color)
       `(".url-host"
         :flex "0 0 auto"
         :color ,theme:on-background-color)
       `(".url-tail"
         :flex "0 1 auto"
         :overflow "hidden"
         :text-overflow "ellipsis"
         :white-space "nowrap"
         :color ,theme:primary-color)
       `(".spinner"
         :flex "0 0 auto"
         :display "inline-block"
         :width "7px"
         :height "7px"
         :border-radius "50%"
         :border ,(format nil "1px solid ~a" (%hairline theme:on-background-color 0.25))
         :border-top-color ,theme:on-background-color
         :animation "nyxt-spin 700ms linear infinite")
       '("#tabs"
         :flex "0 1 auto"
         :display "flex"
         :align-items "center"
         :gap "10px"
         :height "28px"
         :min-width "0"
         :padding "0"
         :margin "0"
         :line-height "normal"
         :overflow-x "auto"
         :scrollbar-width "none")
       `(".tab"
         :display "inline-flex"
         :align-items "center"
         :gap "6px"
         :flex "0 1 auto"
         :min-width "0"
         :height "28px"
         :max-width "140px"
         :margin "0"
         :padding "0"
         :border "none"
         :border-radius "0"
         :background-color "transparent"
         :color ,theme:primary-color
         :transition "color 120ms ease")
       '(".tab-label"
         :overflow "hidden"
         :text-overflow "ellipsis"
         :white-space "nowrap")
       '(".tab-close"
         :flex "0 0 auto"
         :font-size "9px"
         :opacity "0"
         :transition "opacity 120ms ease")
       '(".tab:hover .tab-close"
         :opacity "0.5")
       '(".tab-close:hover"
         :opacity "1")
       `(".selected-tab"
         :background-color "transparent"
         :color ,theme:on-background-color
         :box-shadow ,(format nil "inset 0 -1px 0 0 ~a" theme:on-background-color))
       `("#modes"
         :flex "0 0 auto"
         :display "flex"
         :align-items "center"
         :height "28px"
         :margin "0"
         :padding "0"
         :line-height "normal"
         :border-radius "0"
         :background-color "transparent"
         :color ,theme:primary-color)
       `("#modes > button"
         :height "28px"
         :padding "0"
         :border-radius "0"
         :font-size "12px"
         :color ,theme:primary-color
         :transition "color 120ms ease")
       '(button
         :border-radius "0")
       `("#modes > button:hover, .tab:hover, #url:hover"
         :color ,theme:on-background-color
         :cursor "pointer"))))))
