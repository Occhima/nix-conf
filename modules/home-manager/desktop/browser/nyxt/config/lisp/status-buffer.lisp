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
      '(format-status
        format-status-load-status
        format-status-url
        format-status-tabs
        format-status-modes))

(defun %status-target (status)
  "Main buffer of STATUS's window, or NIL while the window is being built."
  (alexandria:when-let ((window (window status)))
    (buffer window)))

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
                     (nyxt:set-url (%status-target status))))
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
                         :aria-hidden "true"
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
                     :role "tab"
                     :aria-selected (if (eq current-buffer buffer) "true" "false")
                     :tabindex (if (eq current-buffer buffer) "0" "-1")
                     :title (title buffer)
                     :onclick (ps:ps
                                (nyxt/ps:lisp-eval
                                 (:title "select-tab" :buffer status)
                                 (set-current-buffer buffer)))
                     :onkeydown (ps:ps
                                  (when (or (= (ps:@ event key) "Enter")
                                            (= (ps:@ event key) " "))
                                    (ps:chain event (prevent-default))
                                    (nyxt/ps:lisp-eval
                                     (:title "select-tab" :buffer status)
                                     (set-current-buffer buffer))))
                     (unless (internal-url-p (url buffer))
                       (%favicon-html (quri:uri-domain (url buffer))))
                     (:span :class "tab-label" (%tab-label buffer))
                     (:button :class "tab-close"
                            :type "button"
                            :title "Close tab"
                            :aria-label (format nil "Close ~a" (%tab-label buffer))
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
        :aria-label "Modes"
        `(nyxt:toggle-modes ,buffer)))))

(defmethod format-status ((status status-buffer))
  "URL on the left, tabs centred, modes on the right, laid out by the grid on #container."
  (spinneret:with-html-string
    (:div :id "container"
          (:div :id "url"
                (format-status-load-status status)
                (format-status-url status))
          (:div :id "tabs" :role "tablist" :aria-label "Buffers"
                (format-status-tabs status))
          (:div :id "modes"
                (format-status-modes status)))))

(defun %status-css (theme)
  (format nil "
:root {
  --bar-h: 28px;
  --pill-h: 22px;
  --radius: 6px;
  --pad-x: 8px;
  --gap: 10px;
  --fast: 120ms;
  --ease-out: cubic-bezier(0.2, 0.7, 0.3, 1);
  --fg: ~a;
  --muted: ~a;
  --accent: ~a;
  --warn: ~a;
  --surface: ~a;
  --hover: ~a;
  --active: ~a;
  --line: ~a;
  --mono: ~a;
}
* { box-sizing: border-box; }
html, body { height: 100%; }
body {
  margin: 0;
  overflow: hidden;
  background: var(--surface);
  color: var(--muted);
  font: 12px/1 var(--mono);
  letter-spacing: 0.01em;
  font-variant-numeric: tabular-nums;
  -webkit-font-smoothing: antialiased;
}
::-webkit-scrollbar { display: none; }
button {
  font: inherit;
  color: inherit;
  background: none;
  border: 0;
  margin: 0;
  padding: 0;
  cursor: pointer;
}
:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 1px;
  border-radius: var(--radius);
}

#container {
  container-type: inline-size;
  display: grid;
  grid-template-columns: minmax(10rem, 2fr) minmax(0, 3fr) auto;
  align-items: center;
  gap: var(--gap);
  height: var(--bar-h);
  padding: 0 var(--pad-x);
}

#url {
  display: flex;
  align-items: center;
  gap: var(--pad-x);
  min-width: 0;
}
#url > button {
  display: flex;
  align-items: center;
  gap: 6px;
  min-width: 0;
  height: var(--pill-h);
  padding: 0 var(--pad-x);
  border-radius: var(--radius);
  overflow: hidden;
  transition: background-color var(--fast) ease;
}
#url > button:hover { background: var(--hover); color: var(--fg); }
.url-scheme { flex: none; color: var(--muted); }
.url-scheme.insecure { color: var(--warn); }
.url-host { flex: none; color: var(--fg); font-weight: 500; }
.url-tail {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.keyscheme {
  flex: none;
  padding-left: var(--pad-x);
  border-left: 2px solid var(--line);
  font-size: 10px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
.keyscheme-insert { border-left-color: var(--accent); color: var(--accent); }
.spinner {
  flex: none;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  border: 1px solid var(--line);
  border-top-color: var(--fg);
  animation: nyxt-spin 700ms linear infinite;
}
.dl { flex: none; color: var(--accent); }

#tabs {
  display: flex;
  align-items: center;
  justify-content: safe center;
  gap: 4px;
  min-width: 0;
  overflow-x: auto;
  scrollbar-width: none;
}
.tab {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  flex: 0 1 10rem;
  min-width: 2.75rem;
  max-width: 10rem;
  height: var(--pill-h);
  padding: 0 4px 0 var(--pad-x);
  border-radius: var(--radius);
  cursor: pointer;
  transition: color var(--fast) ease, background-color var(--fast) ease;
}
.tab:hover { background: var(--hover); color: var(--fg); }
.selected-tab { background: var(--active); color: var(--fg); }
.tab .favicon { flex: none; width: 12px; height: 12px; object-fit: contain; opacity: 0.75; }
.tab .favicon-fallback { flex: none; width: 12px; text-align: center; font-size: 9px; }
.selected-tab .favicon { opacity: 1; }
.tab-label {
  flex: 1 1 auto;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.tab-close {
  flex: none;
  display: grid;
  place-items: center;
  width: 16px;
  height: 16px;
  border-radius: 4px;
  font-size: 13px;
  opacity: 0;
  transition: opacity var(--fast) ease, background-color var(--fast) ease;
}
.tab:hover .tab-close,
.tab:focus-within .tab-close,
.selected-tab .tab-close { opacity: 0.55; }
.tab-close:hover, .tab-close:focus-visible { opacity: 1; background: var(--hover); }
.tab-enter { animation: nyxt-tab-in 160ms var(--ease-out) both; }
.tab-leave { pointer-events: none; animation: nyxt-tab-out 160ms ease-in both; }

#modes {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 6px;
}
.mode-name {
  display: inline-flex;
  align-items: center;
  height: 18px;
  padding: 0 7px;
  border-radius: var(--radius);
  background: var(--active);
  color: var(--fg);
  font-size: 10px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
#modes > button {
  height: var(--pill-h);
  padding: 0 var(--pad-x);
  border-radius: var(--radius);
  transition: color var(--fast) ease, background-color var(--fast) ease;
}
#modes > button:hover { background: var(--hover); color: var(--fg); }
#modes > button.modes-drifted { color: var(--accent); }

@keyframes nyxt-spin { to { transform: rotate(360deg); } }
@keyframes nyxt-tab-in {
  from { opacity: 0; max-width: 0; padding-left: 0; padding-right: 0; transform: translateY(3px); }
}
@keyframes nyxt-tab-out {
  to { opacity: 0; max-width: 0; padding-left: 0; padding-right: 0; transform: scale(0.92); }
}

@container (max-width: 760px) {
  .url-tail, .mode-name { display: none; }
  .tab { flex-basis: 6rem; max-width: 7rem; }
}
@container (max-width: 520px) {
  .tab-label { display: none; }
  .tab { flex: none; min-width: 0; padding-right: var(--pad-x); }
  .tab .tab-close { display: none; }
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
"
          (theme:on-background-color theme)
          (theme:primary-color theme)
          (theme:action-color theme)
          (theme:warning-color theme)
          (%hairline (theme:background-color theme) 0.72)
          (%hairline (theme:on-background-color theme) 0.07)
          (%hairline (theme:on-background-color theme) 0.12)
          (%hairline (theme:on-background-color theme) 0.30)
          (%mono-stack (theme:monospace-font-family theme))))

(define-configuration status-buffer
  ((glyph-mode-presentation-p nil)
   (height 45)
   (style (%status-css (theme *browser*)))))
