(in-package #:nyxt-user)

(defun %supersede-status-method (name)
  "Drop the built-in method on `status-buffer' for the generic function NAME.

The CEF renderer dispatches on `(type-of buffer)' against a literal list of
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

(defun %active-downloads ()
  "Downloads worth showing on the bar: in flight or failed."
  (remove-if (lambda (download)
               (member (nyxt/mode/download:status download)
                       '(:finished :canceled :unloaded)))
             (nyxt:downloads *browser*)))

(defun %download-name (download)
  "Human name for DOWNLOAD: file name of the destination, else the URL path.
NIL when neither says anything short."
  (let ((path (namestring (nyxt/mode/download:destination-path download))))
    (unless (str:emptyp path)
      (setf path (file-namestring path)))
    (when (str:emptyp path)
      (setf path (or (quri:uri-path (quri:uri (nyxt/mode/download::url download)))
                     "")))
    (unless (str:emptyp path)
      (str:shorten 16 (string-left-trim "/" path)))))

(defmethod format-status-load-status ((status status-buffer))
  "Keyscheme state at the far left of the bar, then the load indicator.

`format-status' renders this ahead of the URL, which is the one spot on the
bar a modal editor puts its state and the one spot nothing competes for.
Beside the tabs the same label read as another tab, a pill among pills.

Downloads ride here too: the upstream methods on `nyxt/mode/download:download'
below trade Nyxt 4's list-downloads page for this pill, so a download never
steals the buffer you are reading."
  (alexandria:when-let ((buffer (%status-target status)))
    (spinneret:with-html
      (alexandria:when-let ((keyscheme (%keyscheme-label status buffer)))
        (:span :class (format nil "keyscheme keyscheme-~a" keyscheme)
               keyscheme))
      (when (and (web-buffer-p buffer)
                 (eq (nyxt::status buffer) :loading))
        (:span :class "spinner"))
      (loop for download in (%active-downloads)
            do (:span :class "dl"
                      (format nil "↓ ~d%~a"
                              (round (nyxt/mode/download:completion-percentage download))
                              (alexandria:when-let ((name (%download-name download)))
                                (format nil " ~a" name))))))))

(let ((download (find-class 'nyxt/mode/download:download)))
  (alexandria:when-let
      ((method (find-method #'initialize-instance '(:after) (list download) nil)))
    (remove-method #'initialize-instance method))
  (alexandria:when-let
      ((method (find-method #'(setf nyxt/mode/download:status) '()
                            (list (find-class t) download) nil)))
    (remove-method #'(setf nyxt/mode/download:status) method)))

(defmethod initialize-instance :after ((download nyxt/mode/download:download)
                                       &key &allow-other-keys)
  "New downloads stay out of the way.

Upstream Nyxt 4 focuses the list-downloads page the instant a download
starts; the status pill above makes the page optional."
  (hooks:run-hook (nyxt/mode/download::before-download-hook download) download)
  (alexandria:if-let ((name (%download-name download)))
      (echo "Downloading ~a…" name)
      (echo "Download started.")))

(defmethod (setf nyxt/mode/download:status)
    (value (download nyxt/mode/download:download))
  "Mirror of the upstream (setf status) without the buffer steal.

Updates the status text and, on completion, runs the after-download hook;
no list-downloads focus."
  (sb-ext:with-unlocked-packages (:nyxt/mode/download)
    (setf (slot-value download 'nyxt/mode/download::status) value))
  (let ((interface (nyxt/mode/download::status-text download)))
    (setf (user-interface:text interface)
          (format nil "Status: ~(~a~)." value)))
  (case value
    (:finished
     (echo "Downloaded ~a." (or (%download-name download) "file"))
     (hooks:run-hook (nyxt/mode/download::after-download-hook download) download))
    (:failed
     (echo-warning "Failed to download ~a." (or (%download-name download) "file")))))

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

(defvar *tab-motion-ms* 160
  "Length of the tab open and close animations.")

(defvar *tab-born* (make-hash-table :synchronized t)
  "Buffer id -> `get-internal-real-time' of the first render that showed it.")

(defvar *tab-ghosts* '()
  "Closed tabs still animating out: plists of :id :index :label :domain :time.")

(defvar *tab-ghosts-lock* (sb-thread:make-mutex :name "tab-ghosts"))

(defun %tab-age-ms (time)
  (round (* 1000 (- (get-internal-real-time) time))
         internal-time-units-per-second))

(defun %tab-label (buffer)
  (let ((url (url buffer)))
    (cond
      ((not (str:emptyp (title buffer))) (title buffer))
      ((internal-url-p url)
       (format nil "~a:~a" (quri:uri-scheme url) (quri:uri-path url)))
      (t (or (quri:uri-domain url) (render-url url))))))

(defun %tab-motion-style (time)
  "Negative delay so a re-render mid-animation resumes it instead of restarting it."
  (format nil "animation-delay:-~dms" (%tab-age-ms time)))

(defmethod ffi-buffer-delete :before ((buffer buffer))
  "Keep a ghost of BUFFER's tab so the strip can animate it out."
  (alexandria:when-let ((index (position buffer (reverse (buffer-list)))))
    (sb-thread:with-mutex (*tab-ghosts-lock*)
      (push (list :id (id buffer)
                  :index index
                  :label (%tab-label buffer)
                  :domain (unless (internal-url-p (url buffer))
                            (quri:uri-domain (url buffer)))
                  :time (get-internal-real-time))
            *tab-ghosts*))
    (remhash (id buffer) *tab-born*)
    (run-thread "tab-ghost-sweep"
      (sleep (/ (+ *tab-motion-ms* 20) 1000))
      (dolist (window (window-list))
        (ignore-errors (nyxt::update-status-tabs (status-buffer window)))))))

(defun %live-tab-ghosts ()
  (sb-thread:with-mutex (*tab-ghosts-lock*)
    (setf *tab-ghosts*
          (remove-if (lambda (ghost) (> (%tab-age-ms (getf ghost :time)) *tab-motion-ms*))
                     *tab-ghosts*))
    (sort (copy-list *tab-ghosts*) #'< :key (lambda (ghost) (getf ghost :index)))))

(defmethod format-status-tabs ((status status-buffer))
  "Tab strip with per-tab close affordance.

New tabs animate in and closed ones animate out; `*tab-born*' and
`*tab-ghosts*' carry that across the full re-renders Nyxt does on every buffer
change."
  (let* ((buffers (reverse (buffer-list)))
         (current-buffer (%status-target status))
         (now (get-internal-real-time))
         (entries (mapcar (lambda (buffer)
                            (list :buffer buffer
                                  :born (or (gethash (id buffer) *tab-born*)
                                            (setf (gethash (id buffer) *tab-born*) now))))
                          buffers)))
    (dolist (ghost (%live-tab-ghosts))
      (let ((index (min (getf ghost :index) (length entries))))
        (setf entries (append (subseq entries 0 index)
                              (list (list :ghost ghost))
                              (nthcdr index entries)))))
    (when buffers
      (spinneret:with-html
        (loop for entry in entries
              for ghost = (getf entry :ghost)
              for buffer = (getf entry :buffer)
              collect
              (if ghost
                  (:span :class "tab tab-leave"
                         :style (%tab-motion-style (getf ghost :time))
                         (when (getf ghost :domain)
                           (%favicon-html (getf ghost :domain)))
                         (:span :class "tab-label" (getf ghost :label)))
                  (let ((buffer buffer)
                        (born (getf entry :born)))
                    (:span
                     :class (format nil "tab~:[~; selected-tab~]~:[~; tab-enter~]"
                                    (eq current-buffer buffer)
                                    (< (%tab-age-ms born) *tab-motion-ms*))
                     :style (when (< (%tab-age-ms born) *tab-motion-ms*)
                              (%tab-motion-style born))
                     :title (title buffer)
                     :onclick (ps:ps
                                (nyxt/ps:lisp-eval
                                 (:title "select-tab" :buffer status)
                                 (set-current-buffer buffer)))
                     (unless (internal-url-p (url buffer))
                       (%favicon-html (quri:uri-domain (url buffer))))
                     (:span :class "tab-label" (%tab-label buffer))
                     (:span :class "tab-close"
                            :title "Close tab"
                            :onclick (ps:ps
                                       (ps:chain event (stop-propagation))
                                       (nyxt/ps:lisp-eval
                                        (:title "close-tab" :buffer status)
                                        (nyxt:delete-buffer :buffers (list buffer))))
                            *glyph-close*)))))))))

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
     "@keyframes nyxt-tab-in {
        from { opacity: 0; max-width: 0; padding-left: 0; padding-right: 0;
               transform: translateY(3px); } }"
     "@keyframes nyxt-tab-out {
        to { opacity: 0; max-width: 0; padding-left: 0; padding-right: 0;
             transform: scale(0.92); } }"
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
       '("#controls, #new-buffer"
         :display "none")
       `("#url"
         :flex "1 1 0"
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
       '("#buffers"
         :flex "1 1 0")
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
       `(".tab .favicon"
         :width "12px"
         :height "12px"
         :object-fit "contain"
         :opacity "0.75")
       `(".tab .favicon-fallback"
         :width "12px"
         :text-align "center"
         :font-size "9px"
         :color ,theme:primary-color)
       '(".selected-tab .favicon"
         :opacity "1")
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
       '(".tab-close::before"
         :display "none")
       '(".tab-enter"
         :animation "nyxt-tab-in 160ms cubic-bezier(0.2, 0.7, 0.3, 1) both")
       '(".tab-leave"
         :pointer-events "none"
         :animation "nyxt-tab-out 160ms ease-in both")
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
