(in-package #:nyxt-user)

(defvar *feeds* (make-hash-table :test 'equal)
  "Feed name -> (:fetched-at UNIVERSAL-TIME :value VALUE).

The start page renders whatever is cached and fetches what is stale in the
background, so a slow network delays the feeds rather than the page.")

(defvar *feed-ttl* 900
  "Seconds before a fetched feed is refetched.")

(defvar *feeds-fetching-p* nil
  "Whether a fetch thread is already running.")

(defun %http-get (url)
  "Body of URL as a string, or NIL when the request fails."
  (ignore-errors
   (dexador:get url :connect-timeout 5 :read-timeout 10 :force-string t)))

(defun %fetch-weather ()
  "One-line weather for the location wttr.in infers from the exit address."
  (alexandria:when-let ((body (%http-get "https://wttr.in/?format=3&m")))
    (let ((line (string-trim '(#\Space #\Newline #\Return) body)))
      (unless (or (str:emptyp line) (search "Unknown location" line))
        line))))

(defun %fetch-hacker-news ()
  "Front page of Hacker News as a list of plists."
  (alexandria:when-let ((body (%http-get "https://hn.algolia.com/api/v1/search?tags=front_page&hitsPerPage=12")))
    (ignore-errors
     (loop for hit in (alexandria:assoc-value (cl-json:decode-json-from-string body) :hits)
           for id = (alexandria:assoc-value hit :object-i-d)
           collect (list :title (alexandria:assoc-value hit :title)
                         :url (or (alexandria:assoc-value hit :url)
                                  (format nil "https://news.ycombinator.com/item?id=~a" id))
                         :comments-url (format nil "https://news.ycombinator.com/item?id=~a" id)
                         :points (alexandria:assoc-value hit :points)
                         :comments (alexandria:assoc-value hit :num--comments))))))

(defun %bookmark-entries ()
  "Bookmarks as stored on disk, or NIL when the file is missing or unreadable.

`files:content' hands back a sequence whose type depends on the file, so both
readers coerce, rather than leaving a vector for `dolist' to choke on."
  (ignore-errors
   (coerce (files:content (make-instance 'nyxt/mode/bookmark:bookmarks-file))
           'list)))

(defun %recent-history (count)
  "The COUNT most recently written history entries."
  (ignore-errors
   (alexandria:when-let ((entries (coerce (files:content (make-instance 'history-file))
                                          'list)))
     (subseq (reverse entries) 0 (min count (length entries))))))

(defun %entry-domain (entry)
  (ignore-errors (quri:uri-domain (url entry))))

(defun %needed-favicon-domains ()
  "Unique domains the start page is about to render an icon for."
  (remove-duplicates
   (remove nil (append (mapcar #'%entry-domain (%bookmark-entries))
                        (mapcar #'%entry-domain (%recent-history 8))))
   :test #'string=))

(defun %favicon-fetchable-domains ()
  "Domains the start page wants an icon for that are worth requesting now.

The render path and the fetch thread share this one list, so the page can
never ask for work the fetcher will decline: that disagreement is what turns
a permanently unavailable icon into a render, fetch, reload loop."
  (ignore-errors
   (remove-if (lambda (domain)
                (or (probe-file (%favicon-path domain))
                    (not (%favicon-stale-attempt-p domain))))
              (%needed-favicon-domains))))

(defun %engine-shortcut (engine)
  (ignore-errors (slot-value engine 'nyxt::shortcut)))

(defun %today ()
  (local-time:format-timestring
   nil (local-time:now)
   :format '(:long-weekday ", " :day " " :long-month " " :year)))

(defun %now ()
  "The current time, rendered here rather than left to the page's script.

Internal pages are served over the `nyxt:' scheme and an inline script does
not always get to run under it, which left the clock reading `--:--'.  Drawn
on the server it is right when the page opens, and the script only has to
keep it moving."
  (local-time:format-timestring
   nil (local-time:now) :format '((:hour 2) ":" (:min 2))))

(defun %feed (name)
  (getf (gethash name *feeds*) :value))

(defun %feed-stale-p (name)
  (alexandria:if-let ((fetched-at (getf (gethash name *feeds*) :fetched-at)))
    (> (- (get-universal-time) fetched-at) *feed-ttl*)
    t))

(defun (setf %feed) (value name)
  (setf (gethash name *feeds*)
        (list :fetched-at (get-universal-time) :value value)))

(defun %refresh-feeds (buffer)
  "Fetch what the start page is missing in a thread, reloading BUFFER only
if something new arrived.

The reload is conditional because an unconditional one makes any resource
that stays unavailable reload the page forever, and every render hands the
renderer another callback socket: a few seconds of that exhausts them and
takes the browser down with it.  The whole body is guarded for the same
reason, an unhandled condition in a thread being fatal to a Nyxt started
with `--disable-debugger'."
  (let ((weather-p (%feed-stale-p "weather"))
        (news-p (%feed-stale-p "hacker-news"))
        (domains (%favicon-fetchable-domains)))
    (when (and (not *feeds-fetching-p*) (or weather-p news-p domains))
      (setf *feeds-fetching-p* t)
      (bt:make-thread
       (lambda ()
         (let ((fetched nil))
           (unwind-protect
                (ignore-errors
                 (when weather-p
                   (setf (%feed "weather") (%fetch-weather)
                         fetched t))
                 (when news-p
                   (setf (%feed "hacker-news") (%fetch-hacker-news)
                         fetched t))
                 (dolist (domain domains)
                   (when (%favicon-fetch domain)
                     (setf fetched t))))
             (setf *feeds-fetching-p* nil)
             (when fetched
               (ignore-errors (ffi-buffer-reload buffer))))))
       :name "nyxt-user feeds"))))

(defun %start-page-style ()
  (theme:themed-css (theme *browser*)
    `(body
      :background-color ,theme:background-color
      :color ,theme:on-background-color
      :font-family ,(%sans-stack theme:font-family)
      :max-width "none"
      :padding "0")
    '("#start"
      :min-height "100vh"
      :display "flex"
      :flex-direction "column"
      :gap "36px"
      :padding "8vh 6vw"
      :box-sizing "border-box")
    '("#start header"
      :display "flex"
      :align-items "baseline"
      :justify-content "space-between"
      :gap "20px"
      :flex-wrap "wrap")
    `("#start h1"
      :margin "0"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "13px"
      :font-weight "400"
      :letter-spacing "0.32em"
      :text-transform "uppercase"
      :color ,theme:primary-color)
    `("#start .meta"
      :display "flex"
      :align-items "baseline"
      :gap "10px"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "12px"
      :color ,theme:primary-color)
    `("#start .clock"
      :font-size "15px"
      :font-variant-numeric "tabular-nums"
      :color ,theme:on-background-color)
    `("#start .meta .weather"
      :color ,theme:on-background-color)
    '("#start .columns"
      :display "grid"
      :grid-template-columns "repeat(auto-fit, minmax(280px, 1fr))"
      :gap "36px"
      :align-items "start")
    '("#start .wide"
      :grid-column "span 2"
      :min-width "0")
    `("#start h2"
      :margin "0 0 14px 0"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "10px"
      :font-weight "400"
      :letter-spacing "0.18em"
      :text-transform "uppercase"
      :color ,theme:primary-color)
    '("#start ul"
      :list-style "none"
      :margin "0"
      :padding "0")
    '("#start li"
      :margin "0 0 9px 0"
      :overflow "hidden"
      :text-overflow "ellipsis"
      :white-space "nowrap")
    '("#start li:last-child"
      :margin-bottom "0")
    `("#start a"
      :color ,theme:on-background-color
      :font-size "15px"
      :text-decoration "none"
      :border-bottom ,(format nil "1px solid ~a"
                              (%hairline theme:on-background-color 0.20)))
    `("#start a:hover"
      :border-bottom-color ,theme:on-background-color)
    `(".favicon"
      :display "inline-block"
      :flex "0 0 auto"
      :width "13px"
      :height "13px"
      :margin-right "8px"
      :object-fit "contain"
      :vertical-align "-2px"
      :opacity "0.85")
    `(".favicon-fallback"
      :display "inline-block"
      :width "13px"
      :text-align "center"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "10px"
      :color ,theme:primary-color)
    `("#start .news .points"
      :display "inline-block"
      :min-width "4ch"
      :margin-right "10px"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "12px"
      :text-align "right"
      :color ,theme:primary-color)
    `("#start .news .comments"
      :margin-left "8px"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "11px"
      :color ,theme:primary-color
      :border "none")
    `("#start .shortcut"
      :display "inline-block"
      :min-width "4ch"
      :margin-right "10px"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "13px"
      :color ,theme:primary-color)
    `("#start .engine"
      :font-size "14px"
      :color ,theme:on-background-color)
    `("#start .history a"
      :display "inline-flex"
      :align-items "center"
      :font-size "14px"
      :color ,theme:primary-color
      :border-bottom "none")
    `("#start .history a:hover"
      :color ,theme:on-background-color)
    `("#start .empty"
      :margin "0"
      :font-size "14px"
      :color ,theme:primary-color)
    `("#start button"
      :padding "0"
      :border "none"
      :border-radius "0"
      :background-color "transparent"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "12px"
      :color ,theme:primary-color
      :cursor "pointer")
    `("#start button:hover"
      :color ,theme:on-background-color)))

(define-command refresh-start-page ()
  "Drop the cached feeds and reload the start page."
  (clrhash *feeds*)
  (ffi-buffer-reload (current-buffer)))

(declaim (ftype function start-page))

(define-internal-page-command-global start-page ()
    (buffer "*Start*")
  "Landing page: clock, weather, Hacker News, bookmarks, history and search
shortcuts."
  (%refresh-feeds buffer)
  (spinneret:with-html-string
    (:nstyle (style buffer))
    (:nstyle (%start-page-style))
    (:div :id "start"
          (:header
           (:h1 "nyxt")
           (:span :class "meta"
                  (:span :id "nyxt-clock" :class "clock" (%now))
                  (:span (%today))
                  (:span :class "weather"
                         (or (%feed "weather") "weather unavailable"))
                  (:nbutton :text "refresh" '(refresh-start-page)))
           (:script
            (:raw "(function () {
  var clock = document.getElementById('nyxt-clock');
  if (!clock) { return; }
  var pad = function (n) { return ('0' + n).slice(-2); };
  var tick = function () {
    var now = new Date();
    clock.textContent = pad(now.getHours()) + ':' + pad(now.getMinutes());
  };
  tick();
  setInterval(tick, 10000);
})();")))
          (:div :class "columns"
                (:section :class "news wide"
                          (:h2 "Hacker News")
                          (alexandria:if-let ((stories (%feed "hacker-news")))
                            (:ul (dolist (story stories)
                                   (:li (:span :class "points"
                                               (or (getf story :points) 0))
                                        (:a :href (getf story :url)
                                            (getf story :title))
                                        (:a :class "comments"
                                            :href (getf story :comments-url)
                                            (format nil "~a comments"
                                                    (or (getf story :comments) 0))))))
                            (:p :class "empty" "Fetching stories…")))
                (:section
                 (:h2 "Bookmarks")
                 (alexandria:if-let ((entries (%bookmark-entries)))
                   (:ul (dolist (entry entries)
                          (:li (:a :href (render-url (url entry))
                                   (%favicon-html (%entry-domain entry))
                                   (if (str:emptyp (title entry))
                                       (render-url (url entry))
                                       (title entry))))))
                   (:p :class "empty" "No bookmarks yet.")))
                (:section
                 (:h2 "Search")
                 (:ul (dolist (engine *extra-search-engines*)
                        (:li (:span :class "shortcut" (%engine-shortcut engine))
                             (:span :class "engine" (name engine))))))
                (:section :class "history"
                          (:h2 "Recent")
                          (alexandria:if-let ((entries (%recent-history 8)))
                            (:ul (dolist (entry entries)
                                   (:li (:a :href (render-url (url entry))
                                            (%favicon-html (%entry-domain entry))
                                            (if (str:emptyp (title entry))
                                                (render-url (url entry))
                                                (title entry))))))
                            (:p :class "empty" "No history yet.")))))))
