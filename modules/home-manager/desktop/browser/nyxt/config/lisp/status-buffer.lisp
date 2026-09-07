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

(defun %mode-label (status mode)
  "Status label for MODE, or NIL when it asked not to be named.

The `-mode' every class name carries is noise once the label sits on a bar
that holds nothing but modes."
  (alexandria:when-let ((label (mode-status status mode)))
    (str:replace-all "-mode" "" label)))

(defun %visible-modes (buffer)
  "BUFFER's modes worth naming, keyscheme mode first.

`sort-modes-for-status' drops the modes that set `visible-in-status-p' to
nil -- document, hint and small-web among them -- so what comes back is the
handful that says something about this buffer rather than every mode it
happens to run."
  (ignore-errors
   (nyxt::sort-modes-for-status (nyxt::enabled-modes buffer))))

(defun %keyscheme-label (status buffer)
  "Label of BUFFER's keyscheme mode, or NIL when none is enabled."
  (alexandria:when-let ((mode (first (%visible-modes buffer))))
    (when (typep mode 'nyxt/mode/keyscheme:keyscheme-mode)
      (%mode-label status mode))))

(defun %other-mode-labels (status buffer)
  "Labels of BUFFER's visible modes, the keyscheme one excepted."
  (let ((modes (%visible-modes buffer)))
    (loop for mode in (if (and modes
                               (typep (first modes)
                                      'nyxt/mode/keyscheme:keyscheme-mode))
                          (rest modes)
                          modes)
          for label = (%mode-label status mode)
          when label
            collect label)))

(defmethod mode-status ((status status-buffer)
                        (mode nyxt/mode/vi:vi-normal-mode))
  "normal")

(defmethod mode-status ((status status-buffer)
                        (mode nyxt/mode/vi:vi-insert-mode))
  "insert")

(defmethod format-status-load-status ((status status-buffer))
  "Keyscheme state at the far left of the bar, then the load indicator.

`format-status' renders this ahead of the URL, which is the one spot on the
bar a modal editor puts its state and the one spot nothing competes for.
Beside the tabs the same label read as another tab, a pill among pills."
  (alexandria:when-let ((buffer (%status-target status)))
    (spinneret:with-html
      (alexandria:when-let ((keyscheme (%keyscheme-label status buffer)))
        (:span :class (format nil "keyscheme keyscheme-~a" keyscheme)
               keyscheme))
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
                   (label (cond
                            ((not (str:emptyp (title buffer))) (title buffer))
                            ((internal-url-p url)
                             (format nil "~a:~a"
                                     (quri:uri-scheme url) (quri:uri-path url)))
                            (t (or (quri:uri-domain url) (render-url url))))))
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

(defun %baseline-mode-names (buffer)
  "Class names BUFFER should be running per its `default-modes' slot, keyscheme excepted.

Keyscheme is excluded because switching between its own submodes (normal,
insert) is expected churn, not a deviation worth flagging."
  (remove-if (lambda (name) (subtypep name 'nyxt/mode/keyscheme:keyscheme-mode))
             (default-modes buffer)))

(defun %active-mode-names (buffer)
  "Class names of BUFFER's live modes, keyscheme excepted."
  (loop for mode in (nyxt::enabled-modes buffer)
        unless (typep mode 'nyxt/mode/keyscheme:keyscheme-mode)
          collect (class-name (class-of mode))))

(defun %modes-drifted-p (buffer)
  "T when BUFFER is running a mode set other than its declared baseline.

Lets the toggle glyph stay quiet during normal browsing and only draw the eye
once something has actually been turned on or off by hand."
  (and (set-exclusive-or (%baseline-mode-names buffer) (%active-mode-names buffer))
       t))

(defmethod format-status-modes ((status status-buffer))
  "The modes worth naming, then the toggle the rest live behind."
  (alexandria:when-let ((buffer (%status-target status)))
    (spinneret:with-html
      (dolist (label (%other-mode-labels status buffer))
        (:span :class "mode-name" label))
      (:nbutton :buffer status
        :class (if (%modes-drifted-p buffer) "modes-toggle modes-drifted" "modes-toggle")
        :text *glyph-modes*
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
         :height "22px"
         :margin "3px 0"
         :padding "0 8px"
         :border-radius "6px"
         :overflow "hidden"
         :transition "background-color 120ms ease")
       `("#url button:hover"
         :background-color ,(%hairline theme:on-background-color 0.06))
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
         :height "22px"
         :max-width "140px"
         :margin "3px 0"
         :padding "0 8px"
         :border "none"
         :border-radius "6px"
         :background-color "transparent"
         :color ,theme:primary-color
         :transition "color 120ms ease, background-color 120ms ease")
       `(".tab:hover"
         :background-color ,(%hairline theme:on-background-color 0.06))
       '(".tab-label"
         :overflow "hidden"
         :text-overflow "ellipsis"
         :white-space "nowrap")
       '(".tab-close"
         :flex "0 0 auto"
         :font-size "14px"
         :line-height "1"
         :padding "2px"
         :opacity "0"
         :transition "opacity 120ms ease")
       '(".tab:hover .tab-close"
         :opacity "0.5")
       '(".tab-close:hover"
         :opacity "1")
       `(".selected-tab"
         :background-color ,(%hairline theme:on-background-color 0.10)
         :color ,theme:on-background-color)
       `(".keyscheme"
         :flex "0 0 auto"
         :display "inline-flex"
         :align-items "center"
         :height "14px"
         :padding-left "8px"
         :border-left ,(format nil "2px solid ~a"
                               (%hairline theme:on-background-color 0.30))
         :font-size "10px"
         :letter-spacing "0.14em"
         :text-transform "uppercase"
         :color ,theme:primary-color)
       `(".keyscheme-insert"
         :border-left-color ,theme:action-color
         :color ,theme:action-color)
       `(".mode-name"
         :flex "0 0 auto"
         :display "inline-flex"
         :align-items "center"
         :height "18px"
         :padding "0 7px"
         :border-radius "6px"
         :background-color ,(%hairline theme:on-background-color 0.10)
         :font-size "10px"
         :letter-spacing "0.08em"
         :text-transform "uppercase"
         :color ,theme:on-background-color)
       `("#modes"
         :flex "0 0 auto"
         :display "flex"
         :align-items "center"
         :gap "8px"
         :height "28px"
         :margin "0"
         :padding "0"
         :line-height "normal"
         :border-radius "0"
         :background-color "transparent"
         :color ,theme:primary-color)
       `("#modes > button"
         :height "22px"
         :margin "3px 0"
         :padding "0 8px"
         :border-radius "6px"
         :font-size "12px"
         :color ,theme:primary-color
         :transition "color 120ms ease, background-color 120ms ease")
       `("#modes > button:hover"
         :background-color ,(%hairline theme:on-background-color 0.06))
       `("#modes > button.modes-drifted"
         :color ,theme:action-color)
       '(button
         :border-radius "0")
       `("#modes > button:hover, .tab:hover, #url:hover"
         :color ,theme:on-background-color
         :cursor "pointer"))))))
