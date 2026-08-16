(in-package #:nyxt-user)

(when (probe-file #p"~/.config/flake-themes/nyxt/theme.lisp")
  (load #p"~/.config/flake-themes/nyxt/theme.lisp"))

(defvar *my-search-engines*
  (list
   (make-instance 'search-engine :name "Google" :shortcut "g"
                                 :control-url "https://google.com/search?q=~a"
                                 :control-completion-url
                                 "https://suggestqueries.google.com/complete/search?client=firefox&q=~a")
   (make-instance 'search-engine :name "MyNixos" :shortcut "mn"
                                 :control-url "https://mynixos.com/search?q=~a")
   (make-instance 'search-engine :name "Noogle" :shortcut "no"
                                 :control-url "https://noogle.dev/?q.txt=~a")
   (make-instance 'search-engine :name "Nixpkgs Issues" :shortcut "npi"
                                 :control-url "https://github.com/NixOS/nixpkgs/issues?q=~a")
   (make-instance 'search-engine :name "Home Manager Options" :shortcut "hm"
                                 :control-url "https://home-manager-options.extranix.com/?query=~a")
   (make-instance 'search-engine :name "GitHub" :shortcut "git"
                                 :control-url "https://github.com/search?q=~a")
   (make-instance 'search-engine :name "Google Scholar" :shortcut "gs"
                                 :control-url "https://scholar.google.com/scholar?q=~a")
   (make-instance 'search-engine :name "Reddit" :shortcut "r"
                                 :control-url "https://old.reddit.com/search?q=~a")
   (make-instance 'search-engine :name "YouTube" :shortcut "yt"
                                 :control-url "https://yewtu.be/search?q=~a")
   (make-instance 'search-engine :name "Arxiv" :shortcut "ax"
                                 :control-url "https://arxiv.org/search?query=~a&searchtype=all&source=header")
   (make-instance 'search-engine :name "Arch Linux AUR" :shortcut "arch"
                                 :control-url "https://aur.archlinux.org/packages?O=0&K=~a")
   (make-instance 'search-engine :name "Flathub" :shortcut "fl"
                                 :control-url "https://flathub.org/apps/search?q=~a")))

(defmethod files:resolve ((profile nyxt:nyxt-profile)
                          (file nyxt/mode/bookmark:bookmarks-file))
  #p"~/.config/nyxt/bookmarks.lisp")

(define-configuration (browser)
  ((external-editor-program (if (member :flatpak *features*)
                                "flatpak-spawn --host emacsclient -c"
                                "emacsclient -c"))
   (search-engines (append %slot-default% *my-search-engines*))
   (search-engine-suggestions-p t)))

(define-configuration nyxt/mode/password:password-mode
  ((nyxt/mode/password:password-interface
    (make-instance 'password:password-store-interface
                   :executable (if (member :flatpak *features*)
                                   "flatpak-spawn --host pass"
                                   "pass")))))

(define-configuration nyxt/mode/hint:hint-mode
  ((nyxt/mode/hint:hints-alphabet "DSJKHLFAGNMXCWEIO")
   (nyxt/mode/hint:hints-selector
    "a, button, input, textarea, details, select, [role=button], [role=link], [onclick], summary")))

(defvar *glyph-close* (string (code-char #x00D7)))
(defvar *glyph-modes* (string (code-char #x2261)))

(defun %mono-stack (family)
  (format nil "~a, 'dejavu sans mono', ui-monospace, monospace" family))

(defun %sans-stack (family)
  (format nil "~a, 'public sans', ui-sans-serif, sans-serif" family))

(define-configuration status-buffer
  ((glyph-mode-presentation-p nil)))

(defmethod format-status-buttons ((status status-buffer))
  "Navigation controls, rendered as a compact icon cluster."
  (spinneret:with-html
    (:nbutton :buffer status :text (:raw (nyxt::glyph-left status))
      :title "Back"
      '(nyxt/mode/history:history-backwards))
    (:nbutton :buffer status :text (:raw (nyxt::glyph-right status))
      :title "Forward"
      '(nyxt/mode/history:history-forwards))
    (:nbutton :buffer status :id "reload" :text (:raw (nyxt::glyph-reload status))
      :title "Reload"
      '(nyxt:reload-current-buffer))
    (:nbutton :buffer status :text (:raw (nyxt::glyph-lambda status))
      :title "Execute command"
      '(nyxt:execute-command))))

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
  "Tab strip with per-tab close affordance."
  (let* ((buffers (reverse (buffer-list)))
         (current-buffer (%status-target status)))
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
                      *glyph-close*)))))))

(defmethod format-status-modes ((status status-buffer))
  "Mode list behind a single toggle glyph."
  (alexandria:when-let ((buffer (%status-target status)))
    (spinneret:with-html
      (:nbutton :buffer status :text *glyph-modes*
        :title (nyxt::modes-string buffer)
        '(nyxt:toggle-modes))
      (loop for mode in (nyxt::sort-modes-for-status (enabled-modes buffer))
            collect
            (let ((mode mode))
              (alexandria:when-let ((formatted-mode (mode-status status mode)))
                (:nbutton :buffer status :text formatted-mode
                  :title (format nil "Describe ~a" mode)
                  `(describe-class :class (quote ,(name mode))))))))))

(defun %hairline (color alpha)
  (format nil "color-mix(in srgb, ~a ~a%, transparent)"
          color (round (* alpha 100))))

(define-configuration status-buffer
  ((style
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
         :border-top ,(format nil "1px solid ~a"
                              (%hairline theme:on-background-color 0.10)))
       '("#container"
         :display "flex"
         :align-items "center"
         :gap "14px"
         :height "34px"
         :padding "0 12px"
         :box-sizing "border-box")
       '("#controls"
         :flex "0 0 auto"
         :display "flex"
         :align-items "center"
         :gap "10px"
         :margin-top "0")
       `("#controls > button svg"
         :width "11px"
         :height "11px"
         :stroke ,theme:primary-color-
         :fill ,theme:primary-color-)
       `("#controls > button:hover svg"
         :stroke ,theme:on-background-color
         :fill ,theme:on-background-color)
       `("#controls > button"
         :max-width "none"
         :width "auto"
         :height "34px"
         :aspect-ratio "auto"
         :margin-right "0"
         :border-radius "0"
         :display "inline-flex"
         :align-items "center"
         :font-size "12px"
         :color ,theme:primary-color-
         :transition "color 120ms ease")
       `("#url"
         :flex "3 2 220px"
         :min-width "160px"
         :display "flex"
         :align-items "center"
         :height "34px"
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
         :gap "8px"
         :width "100%"
         :height "34px"
         :overflow "hidden")
       `(".url-scheme"
         :flex "0 0 auto"
         :color ,theme:primary-color-)
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
         :color ,theme:primary-color-)
       `(".spinner"
         :flex "0 0 auto"
         :display "inline-block"
         :width "8px"
         :height "8px"
         :border-radius "50%"
         :border ,(format nil "1px solid ~a" (%hairline theme:on-background-color 0.25))
         :border-top-color ,theme:on-background-color
         :animation "nyxt-spin 700ms linear infinite")
       '("#tabs"
         :flex "10 4 auto"
         :display "flex"
         :align-items "center"
         :gap "16px"
         :height "34px"
         :min-width "80px"
         :padding "0"
         :margin "0"
         :line-height "normal"
         :overflow-x "auto")
       `(".tab"
         :display "inline-flex"
         :align-items "center"
         :gap "8px"
         :flex "0 0 auto"
         :height "34px"
         :max-width "200px"
         :margin "0"
         :padding "0"
         :border "none"
         :border-radius "0"
         :background-color "transparent"
         :color ,theme:primary-color-
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
         :gap "8px"
         :height "34px"
         :margin "0"
         :padding "0"
         :line-height "normal"
         :border-radius "0"
         :background-color "transparent"
         :color ,theme:primary-color-)
       `("#modes > button"
         :height "34px"
         :padding "0"
         :border-radius "0"
         :font-size "11px"
         :color ,theme:primary-color-
         :transition "color 120ms ease")
       '(button
         :border-radius "0")
       `("#controls > button:hover, #modes > button:hover, .tab:hover, #url:hover"
         :color ,theme:on-background-color
         :cursor "pointer")))))
  (height 34))

(define-configuration message-buffer
  ((height 20)
   (style
    (str:concat
     %slot-value%
     (theme:themed-css (theme *browser*)
       `(body
         :background-color ,theme:background-color
         :color ,theme:primary-color-
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "11px"
         :line-height "20px"
         :letter-spacing "0.01em"
         :padding "0 12px"))))))

(defvar *palette-max-width* 720)
(defvar *palette-width-ratio* 0.46)
(defvar *palette-max-height* 440)
(defvar *palette-height-ratio* 0.52)
(defvar *palette-top-ratio* 0.16)

(defmethod (setf nyxt::ffi-height) :after ((height integer)
                                           (prompt-buffer prompt-buffer))
  (ignore-errors
   (with-slots (window) prompt-buffer
     (when (plusp height)
       (let* ((bounds (uiop:symbol-call :electron :get-bounds window))
              (window-width (alexandria:assoc-value bounds :width))
              (window-height (alexandria:assoc-value bounds :height))
              (palette-width (min *palette-max-width*
                                  (round (* window-width *palette-width-ratio*))))
              (palette-height (min *palette-max-height*
                                   (round (* window-height *palette-height-ratio*)))))
         (uiop:symbol-call :electron :set-background-color
                           prompt-buffer "#00000000")
         (uiop:symbol-call :nyxt/renderer/electron
                           :update-active-buffer-bounds window 0)
         (uiop:symbol-call :electron :set-bounds prompt-buffer
                           :x (round (/ (- window-width palette-width) 2))
                           :y (round (* window-height *palette-top-ratio*))
                           :width palette-width
                           :height palette-height))))))

(define-configuration (prompt-buffer)
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
         :row-gap "10px"
         :padding "12px"
         :border-radius "16px"
         :background-color ,(%hairline theme:background-color 0.93)
         :border ,(format nil "1px solid ~a"
                          (%hairline theme:on-background-color 0.22))
         :box-shadow "0 18px 50px rgba(0,0,0,0.55)"
         :animation "nyxt-palette-in 150ms cubic-bezier(0.2, 0.7, 0.3, 1) both")
       `("#prompt-area"
         :margin "0"
         :height "42px"
         :align-items "center"
         :border "none"
         :border-radius "12px"
         :background-color "transparent"
         :box-shadow ,(format nil "inset 0 0 0 1px ~a"
                              (%hairline theme:on-background-color 0.22)))
       `("#prompt"
         :background-color "transparent"
         :color ,theme:primary-color-
         :font-size "11px"
         :letter-spacing "0.06em"
         :text-transform "lowercase"
         :line-height "42px"
         :padding "0 2px 0 14px"
         :max-width "24ch")
       '("#prompt-input"
         :line-height "42px"
         :padding "0 6px"
         :min-width "12ch")
       `("#prompt-extra"
         :background-color "transparent"
         :color ,theme:primary-color-
         :font-size "11px"
         :line-height "42px"
         :padding-right "14px")
       '("#prompt-modes, #close-button"
         :display "none")
       `(input
         :font-family ,(%mono-stack theme:monospace-font-family))
       `("#input"
         :height "42px"
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
         :margin "0 0 10px 0")
       '(".source:last-of-type"
         :margin-bottom "0")
       `(".source-name"
         :background-color "transparent"
         :color ,theme:primary-color-
         :font-size "10px"
         :letter-spacing "0.10em"
         :text-transform "uppercase"
         :border-radius "0"
         :border "none"
         :padding "0 0 6px 10px")
       '(".source-name > div"
         :line-height "14px")
       '(".source-content th"
         :display "none")
       `(".source-content"
         :padding-left "0"
         :margin-left "0"
         :border-spacing "0 2px"
         (td
          :height "26px"
          :padding "0 10px"
          :border-radius "6px"
          :color ,theme:primary-color)
         ("td:first-child"
          :color ,theme:on-background-color)
         ("tr:hover td"
          :background-color ,(%hairline theme:on-background-color 0.07)))
       `("#selection td"
         :background-color ,theme:primary-color
         :color ,theme:on-primary-color)
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

(define-configuration web-buffer
  ((style
    (str:concat
     %slot-value%
     (theme:themed-css (theme *browser*)
       `(body
         :background-color ,theme:background-color
         :color ,theme:on-background-color
         :font-family ,(%sans-stack theme:font-family)
         :font-size "15px"
         :line-height "1.65"
         :padding "32px 40px 64px 40px"
         :max-width "58rem"
         :margin "0 auto")
       `("h1, h2, h3, h4, h5, h6"
         :font-family ,(%sans-stack theme:font-family)
         :font-weight "600"
         :letter-spacing "-0.015em"
         :line-height "1.25"
         :margin-top "1.8em"
         :margin-bottom "0.5em")
       '(h1 :font-size "1.9em" :margin-top "0")
       '(h2 :font-size "1.45em")
       '(h3 :font-size "1.15em")
       `(a
         :color ,theme:on-background-color
         :text-decoration "none"
         :border-bottom ,(format nil "1px solid ~a"
                                 (%hairline theme:on-background-color 0.30))
         :transition "border-color 120ms ease")
       `("a:hover"
         :border-bottom-color ,theme:on-background-color)
       `("code, pre, kbd, samp"
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "0.9em")
       `("pre, p code"
         :background-color ,theme:background-color+
         :color ,theme:on-background-color
         :border-radius "8px")
       `(pre
         :padding "14px 16px"
         :overflow-x "auto"
         :line-height "1.5"
         :border ,(format nil "1px solid ~a"
                          (%hairline theme:on-background-color 0.10)))
       '("p code, li code, td code"
         :padding "1px 5px"
         :border-radius "4px")
       `(blockquote
         :margin "1.2em 0"
         :padding "2px 0 2px 16px"
         :border-left ,(format nil "2px solid ~a"
                               (%hairline theme:on-background-color 0.25))
         :color ,theme:primary-color)
       `(hr
         :border "none"
         :height "1px"
         :margin "2em 0"
         :background-color ,(%hairline theme:on-background-color 0.10))
       '(table
         :border-radius "8px"
         :border-collapse "separate"
         :border-spacing "0"
         :overflow "hidden")
       `("table, th, td"
         :border-color ,(%hairline theme:on-background-color 0.10))
       '("td, th"
         :padding "9px 12px")
       `(th
         :background-color ,theme:background-color+
         :color ,theme:primary-color
         :font-weight "500"
         :font-size "0.8em"
         :letter-spacing "0.06em"
         :text-transform "uppercase")
       '("th:first-of-type" :border-top-left-radius "8px")
       '("th:last-of-type" :border-top-right-radius "8px")
       '("tr:last-of-type td:first-of-type" :border-bottom-left-radius "8px")
       '("tr:last-of-type td:last-of-type" :border-bottom-right-radius "8px")
       `(".mode-menu"
         :background-color ,theme:background-color
         :height "38px"
         :margin-top "-10px"
         :display "flex"
         :align-items "center"
         :gap "14px"
         :border-bottom ,(format nil "1px solid ~a"
                                 (%hairline theme:on-background-color 0.10)))
       `(".mode-menu > button"
         :height "24px"
         :margin-right "0"
         :padding "0"
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "11px"
         :border-radius "0"
         :background-color "transparent"
         :color ,theme:primary-color-
         :transition "color 120ms ease")
       `(".mode-menu > .command"
         :color ,theme:primary-color)
       `(".mode-menu > button:hover"
         :color ,theme:on-background-color
         :cursor "pointer")
       '(dl
         :row-gap "8px"
         :column-gap "14px")
       `(dt
         :background-color ,theme:background-color+
         :color ,theme:on-background-color
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-weight "400"
         :font-size "0.9em"
         :border-radius "6px"
         :padding "3px 9px"
         :height "fit-content")
       `("::selection"
         :background-color ,theme:primary-color
         :color ,theme:on-primary-color)
       '("::-webkit-scrollbar"
         :width "8px")
       '("::-webkit-scrollbar-track"
         :background "transparent")
       `("::-webkit-scrollbar-thumb"
         :background-color ,(%hairline theme:on-background-color 0.18)
         :border-radius "8px"))))))
