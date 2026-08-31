(in-package #:nyxt-user)

(defvar *feeds* (make-hash-table :test 'equal)
  "Feed name -> (:fetched-at UNIVERSAL-TIME :value VALUE).

The start page renders whatever is cached and fetches what is stale in the
background, so a slow network delays the feeds rather than the page.")

(defvar *feed-ttl* 900
  "Seconds before a fetched feed is refetched.")

(defvar *feeds-fetching-p* nil
  "Whether a fetch thread is already running.")

(defun %feed (name)
  (getf (gethash name *feeds*) :value))

(defun %feed-stale-p (name)
  (alexandria:if-let ((fetched-at (getf (gethash name *feeds*) :fetched-at)))
    (> (- (get-universal-time) fetched-at) *feed-ttl*)
    t))

(defun (setf %feed) (value name)
  (setf (gethash name *feeds*)
        (list :fetched-at (get-universal-time) :value value)))

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

(defun %refresh-feeds (buffer)
  "Fetch the stale feeds in a thread, reloading BUFFER once they land."
  (when (and (not *feeds-fetching-p*)
             (or (%feed-stale-p "weather") (%feed-stale-p "hacker-news")))
    (setf *feeds-fetching-p* t)
    (bt:make-thread
     (lambda ()
       (unwind-protect
            (progn
              (when (%feed-stale-p "weather")
                (setf (%feed "weather") (%fetch-weather)))
              (when (%feed-stale-p "hacker-news")
                (setf (%feed "hacker-news") (%fetch-hacker-news))))
         (setf *feeds-fetching-p* nil)
         (ignore-errors (ffi-buffer-reload buffer))))
     :name "nyxt-user feeds")))

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

(defun %engine-shortcut (engine)
  (ignore-errors (slot-value engine 'nyxt::shortcut)))

(defun %today ()
  (local-time:format-timestring
   nil (local-time:now)
   :format '(:long-weekday ", " :day " " :long-month " " :year)))

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
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "12px"
      :color ,theme:primary-color)
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
    `("#start a"
      :color ,theme:on-background-color
      :font-size "15px"
      :text-decoration "none"
      :border-bottom ,(format nil "1px solid ~a"
                              (%hairline theme:on-background-color 0.20)))
    `("#start a:hover"
      :border-bottom-color ,theme:on-background-color)
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
  "Landing page: weather, Hacker News, bookmarks, history and search shortcuts."
  (%refresh-feeds buffer)
  (spinneret:with-html-string
    (:nstyle (style buffer))
    (:nstyle (%start-page-style))
    (:div :id "start"
          (:header
           (:h1 "nyxt")
           (:span :class "meta"
                  (:span (%today))
                  " · "
                  (:span :class "weather"
                         (or (%feed "weather") "weather unavailable"))
                  " · "
                  (:nbutton :text "refresh" '(refresh-start-page))))
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
                                            (if (str:emptyp (title entry))
                                                (render-url (url entry))
                                                (title entry))))))
                            (:p :class "empty" "No history yet.")))))))
