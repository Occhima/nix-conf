(in-package #:nyxt-user)

;; ponytail: upstream constructor calls (style (find-submode ...)) which errors
;; (no-applicable-method) when the target buffer lacks search-buffer-mode --
;; status/message/prompt buffers. It runs in the prompter init thread, which
;; aborts while holding initial-suggestions-lock -> prompt wedges as a black
;; box. Guard it, and pass the source's buffer instead of current-buffer.

(define-configuration nyxt/mode/search-buffer:search-buffer-source
  ((prompter:constructor
    (lambda (source)
      (let ((mode (find-submode 'nyxt/mode/search-buffer:search-buffer-mode
                                (buffer source))))
        (when mode
          (add-stylesheet "nyxt-search-stylesheet"
                          (style mode)
                          (buffer source))))))))
