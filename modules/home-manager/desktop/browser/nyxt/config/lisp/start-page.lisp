(in-package #:nyxt-user)

(defvar *feeds* (make-hash-table :test 'equal)
  "Feed name -> (:fetched-at UNIVERSAL-TIME :value VALUE).

The start page renders whatever is cached and fetches what is stale in the
background, so a slow network delays the feeds rather than the page.")

(defvar *feed-ttl* 900
  "Seconds before a fetched feed is refetched.")

(defvar *feeds-fetching-p* nil
  "Whether a fetch thread is already running.")

(defvar *favicon-cache-dir*
  (uiop:ensure-directory-pathname
   (uiop:parse-native-namestring
    (format nil "~a/nyxt/favicons"
            (or (uiop:getenv "XDG_CACHE_HOME")
                (format nil "~a/.cache" (uiop:getenv "HOME"))))))
  "Where fetched favicons are cached, one file per domain, kept forever.")

(defvar *favicon-attempted* (make-hash-table :test 'equal)
  "Domain -> UNIVERSAL-TIME of the last fetch attempt, successful or not.

Recorded even on failure so a domain whose icon 404s is not retried, and the
start page re-rendered, on every single load.")

(defvar *favicon-retry-ttl* 86400
  "Seconds before a failed favicon fetch is retried.")

(defvar *favicon-uris* (make-hash-table :test 'equal)
  "Domain -> data: URI, so a cached icon is read and encoded once per session.")

(defvar *base64-alphabet*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")

(defun %base64 (bytes)
  "BYTES as a base64 string.

Spelled out rather than taken from a library because the image of the binary
release is fixed and nothing guarantees a base64 system was built into it."
  (let ((length (length bytes))
        (out (make-string-output-stream)))
    (loop for index from 0 below length by 3
          for remaining = (- length index)
          for triple = (logior (ash (aref bytes index) 16)
                               (ash (if (> remaining 1) (aref bytes (+ index 1)) 0) 8)
                               (if (> remaining 2) (aref bytes (+ index 2)) 0))
          do (write-char (char *base64-alphabet* (ldb (byte 6 18) triple)) out)
             (write-char (char *base64-alphabet* (ldb (byte 6 12) triple)) out)
             (write-char (if (> remaining 1)
                             (char *base64-alphabet* (ldb (byte 6 6) triple))
                             #\=)
                         out)
             (write-char (if (> remaining 2)
                             (char *base64-alphabet* (ldb (byte 6 0) triple))
                             #\=)
                         out))
    (get-output-stream-string out)))

(defun %favicon-file-name (domain)
  "DOMAIN as a flat file name, a domain not being guaranteed path-safe."
  (substitute-if #\_
                 (lambda (character)
                   (not (or (alphanumericp character)
                            (member character '(#\. #\-)))))
                 domain))

(defun %favicon-path (domain)
  (merge-pathnames (format nil "~a.ico" (%favicon-file-name domain))
                   *favicon-cache-dir*))

(defun %favicon-stale-attempt-p (domain)
  "Whether DOMAIN's icon is worth requesting again."
  (alexandria:if-let ((at (gethash domain *favicon-attempted*)))
    (> (- (get-universal-time) at) *favicon-retry-ttl*)
    t))

(defun %favicon-fetch (domain)
  "Cache DOMAIN's favicon to disk via DuckDuckGo's icon proxy.

Only DOMAIN is sent, not the page URL, and the icon is kept locally after
that so a repeat visit costs no request at all.  The attempt is recorded
before the request rather than after it, so that a domain serving no icon
is retried on a timer instead of on every render."
  (let ((path (%favicon-path domain)))
    (setf (gethash domain *favicon-attempted*) (get-universal-time))
    (ignore-errors
     (let ((bytes (dexador:get (format nil "https://icons.duckduckgo.com/ip3/~a.ico" domain)
                               :connect-timeout 3 :read-timeout 5 :force-binary t)))
       (when (and (typep bytes '(vector (unsigned-byte 8))) (plusp (length bytes)))
         (ensure-directories-exist *favicon-cache-dir*)
         (with-open-file (stream path :direction :output
                                      :element-type '(unsigned-byte 8)
                                      :if-exists :supersede)
           (write-sequence bytes stream))
         path)))))

(defun %image-content-type (bytes)
  "MIME type of BYTES, which the icon proxy serves as either PNG or ICO."
  (if (and (>= (length bytes) 4)
           (equalp (subseq bytes 0 4) #(137 80 78 71)))
      "image/png"
      "image/x-icon"))

(defun %favicon-uri (domain)
  "DOMAIN's cached icon as a data: URI, or NIL while it is not cached.

Internal pages are served over the `nyxt:' scheme and Chromium refuses a
`file://' subresource from any other origin, so the bytes travel inline.
Only a hit is memoised: a miss has to stay a miss no longer than it takes
the icon to land."
  (when domain
    (or (gethash domain *favicon-uris*)
        (alexandria:when-let
            ((uri (ignore-errors
                   (alexandria:when-let ((path (probe-file (%favicon-path domain))))
                     (let ((bytes (alexandria:read-file-into-byte-vector path)))
                       (format nil "data:~a;base64,~a"
                               (%image-content-type bytes) (%base64 bytes)))))))
          (setf (gethash domain *favicon-uris*) uri)))))

(defun %favicon-html (domain)
  "Cached favicon <img>, or a letter-avatar fallback while it is unavailable."
  (spinneret:with-html
    (alexandria:if-let ((uri (%favicon-uri domain)))
      (:img :class "favicon" :src uri :alt "")
      (:span :class "favicon favicon-fallback"
             (if (str:emptyp (or domain "")) "?" (string-upcase (subseq domain 0 1)))))))

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
