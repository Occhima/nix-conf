(in-package #:nyxt-user)

(defun %scroll-after-load (buffer y)
  "Scroll BUFFER to Y once its next load finishes."
  (hooks:once-on (buffer-loaded-hook buffer) (buffer)
    (ps-eval :buffer buffer (ps:chain window (scroll-to 0 (ps:lisp y))))))

(defvar *pip-size* '(480 . 270)
  "Width and height of the picture-in-picture window, in logical pixels.")

(defvar *pip-margin* 24
  "Gap between the picture-in-picture window and the monitor corner.")

(defun %hyprctl (&rest arguments)
  (ignore-errors
   (uiop:run-program (cons "hyprctl" arguments) :output :string :ignore-error-status t)))

(defun %pip-place ()
  "Float and pin the mpv window, then move it to the focused monitor's corner."
  (when (loop repeat 50
              when (search "\"nyxt-pip\"" (or (%hyprctl "clients" "-j") ""))
                return t
              do (sleep 0.1))
    (let* ((monitors (ignore-errors (cl-json:decode-json-from-string (%hyprctl "monitors" "-j"))))
           (monitor (find-if (lambda (m) (alexandria:assoc-value m :focused)) monitors))
           (selector "class:^(nyxt-pip)$")
           (width (car *pip-size*))
           (height (cdr *pip-size*)))
      (%hyprctl "--batch"
                (format nil "dispatch setfloating ~a; dispatch pin ~a; dispatch resizewindowpixel exact ~d ~d,~a~@[; ~a~]"
                        selector selector width height selector
                        (when monitor
                          (let ((scale (or (alexandria:assoc-value monitor :scale) 1)))
                            (format nil "dispatch movewindowpixel exact ~d ~d,~a"
                                    (round (- (+ (alexandria:assoc-value monitor :x)
                                                 (/ (alexandria:assoc-value monitor :width) scale))
                                              width *pip-margin*))
                                    (round (- (+ (alexandria:assoc-value monitor :y)
                                                 (/ (alexandria:assoc-value monitor :height) scale))
                                              height *pip-margin*))
                                    selector))))))))

(define-command-global picture-in-picture (&optional (buffer (current-buffer)))
  "Continue the page's video in a small pinned mpv window, from where it is."
  (let ((start (or (ignore-errors
                    (ps-eval :buffer buffer
                      (let ((video (nyxt/ps:qs document "video")))
                        (if video
                            (progn (ps:chain video (pause))
                                   (ps:@ video current-time))
                            0))))
                   0)))
    (uiop:launch-program (list *mpv*
                               "--wayland-app-id=nyxt-pip"
                               "--x11-name=nyxt-pip"
                               (format nil "--autofit=~dx~d" (car *pip-size*) (cdr *pip-size*))
                               (format nil "--start=~d" (floor start))
                               (quri:render-uri (url buffer)))
                         :output nil :error-output nil)
    (when (uiop:getenv "HYPRLAND_INSTANCE_SIGNATURE")
      (run-thread "picture-in-picture placement" (%pip-place)))
    (echo "Picture-in-picture~@[ from ~ds~]" (when (plusp start) (floor start)))))

(defvar *hibernate-after* 30
  "Minutes a buffer stays out of every window before it is hibernated.")

(defvar *hibernated* (make-hash-table :synchronized t :test 'eq :weakness :key)
  "Hibernated buffers, to the vertical scroll position they wake up at.")

(defun hibernated-p (buffer)
  (nth-value 1 (gethash buffer *hibernated*)))

(defun %playing-media-p (buffer)
  (ignore-errors
   (ps-eval :buffer buffer
     (ps:chain *array (from (nyxt/ps:qsa document "video, audio"))
               (some (lambda (media) (not (ps:@ media paused))))))))

(defun hibernate-buffer (buffer)
  "Drop BUFFER's renderer process, keeping its URL, title and scroll position."
  (unless (or (hibernated-p buffer)
              (nyxt::active-buffer-p buffer)
              (not (web-buffer-p buffer))
              (internal-url-p (url buffer))
              (url-empty-p (url buffer))
              (%playing-media-p buffer))
    (setf (gethash buffer *hibernated*)
          (or (ignore-errors (ps-eval :buffer buffer (ps:@ window scroll-y))) 0))
    (ffi-within-renderer-thread
     (lambda ()
       (when (cef:web-contents buffer)
         (cef:kill buffer))
       (setf (nyxt/renderer/cef::listeners-p buffer) nil)))
    t))

(defun wake-buffer (buffer)
  "Give hibernated BUFFER a renderer again and reload it where it was."
  (multiple-value-bind (scroll hibernated) (gethash buffer *hibernated*)
    (when hibernated
      (remhash buffer *hibernated*)
      (ffi-buffer-initialize-foreign-object buffer)
      (alexandria:when-let ((mode (find-submode 'nyxt/mode/user-script:user-script-mode buffer)))
        (let ((scripts (nyxt/mode/user-script:user-scripts mode)))
          (dolist (script scripts)
            (setf (nyxt/renderer/cef::script-id script) nil))
          (nyxt/mode/user-script::inject-user-scripts scripts buffer)))
      (when (plusp scroll)
        (%scroll-after-load buffer scroll))
      (ffi-buffer-reload buffer))))

(defmethod ffi-window-set-buffer :before (window (buffer web-buffer) &key &allow-other-keys)
  (declare (ignore window))
  (wake-buffer buffer))

(defmethod document-model :around ((buffer web-buffer) &key use-cached-p)
  (declare (ignore use-cached-p))
  (if (hibernated-p buffer)
      (slot-value buffer 'nyxt::document-model)
      (call-next-method)))

(defun hibernate-idle-buffers ()
  (let ((cutoff (local-time:timestamp- (local-time:now) *hibernate-after* :minute)))
    (dolist (buffer (buffer-list))
      (when (local-time:timestamp< (nyxt::last-access buffer) cutoff)
        (hibernate-buffer buffer)))))

(define-command-global hibernate-background-buffers ()
  "Hibernate every buffer that is not shown in a window, idle or not."
  (echo "Hibernated ~a buffers"
        (count-if #'identity (mapcar #'hibernate-buffer (buffer-list)))))

(defvar *hibernation-thread*
  (run-thread "hibernation"
    (loop (sleep 60)
          (ignore-errors (hibernate-idle-buffers))))
  "Checks once a minute for buffers idle longer than `*hibernate-after*'.")

(define-mode isolated-mode ()
  "Marks a buffer with its own cookies, storage and cache, deleted when it closes.")

(defvar *isolate-new-buffer-p* nil
  "When non-nil, web buffers created now get their own CEF request context.")

(defmethod customize-instance :before ((buffer web-buffer) &key &allow-other-keys)
  (when *isolate-new-buffer-p*
    (setf (slot-value buffer 'cef::isolated-context-p) t)))

(defun make-isolated-buffer-at (url)
  (let ((buffer (let ((*isolate-new-buffer-p* t))
                  (make-buffer-focus :url (quri:uri url)))))
    (enable-modes* 'isolated-mode buffer)
    buffer))

(define-command-global make-isolated-buffer ()
  "Open a URL or search in a buffer that shares no cookies or storage."
  (alexandria:when-let ((query (prompt1 :prompt "Open isolated"
                                        :input (render-url (url (current-buffer)))
                                        :sources (make-instance 'nyxt::url-or-query-source
                                                                :actions-on-return #'identity))))
    (make-isolated-buffer-at (url query))))

(define-command-global hint-open-isolated ()
  "Open hinted links in isolated buffers."
  (%hint-links "Open isolated"
               (lambda (links)
                 (dolist (link links)
                   (make-isolated-buffer-at (car link))))))

(defvar *translate-language* "pt"
  "Language code pages and selections are translated into.")

(define-command-global translate-page (&optional (buffer (current-buffer)))
  "Open a translation of the current page in a new buffer."
  (make-buffer-focus
   :url (quri:uri (format nil "https://translate.google.com/translate?sl=auto&tl=~a&u=~a"
                          *translate-language*
                          (quri:url-encode (render-url (url buffer)))))))

(define-command-global translate-selection (&optional (buffer (current-buffer)))
  "Translate the selected text in a new buffer."
  (let ((text (%selection buffer)))
    (if (str:blankp text)
        (echo-warning "Nothing selected.")
        (make-buffer-focus
         :url (quri:uri (format nil "https://translate.google.com/?sl=auto&tl=~a&op=translate&text=~a"
                                *translate-language*
                                (quri:url-encode text)))))))

(define-command-global split-view ()
  "Show a buffer in a new window next to this one, for the window manager to tile."
  (alexandria:when-let
      ((buffer (prompt1 :prompt "Split with"
                        :sources (make-instance 'nyxt::buffer-source
                                                :enable-marks-p nil
                                                :actions-on-current-suggestion-enabled-p nil
                                                :actions-on-return #'identity))))
    (make-window (if (nyxt::active-buffer-p buffer)
                     (make-buffer :url (url buffer))
                     buffer))))
