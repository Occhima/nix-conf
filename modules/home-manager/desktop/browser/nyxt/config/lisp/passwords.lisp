(in-package #:nyxt-user)

(define-class passage-interface (password:password-store-interface)
  ((password:executable "passage")
   (password::password-directory
    (or (uiop:getenv "PASSAGE_DIR")
        (format nil "~a/.config/secrets/store" (uiop:getenv "HOME")))))
  (:documentation "`passage' as Nyxt's password manager.

`passage' keeps the password-store CLI but encrypts with age, so entries end in
.age rather than .gpg and `list-passwords' has to glob for those instead."))

(defmethod password:list-passwords ((interface passage-interface))
  (alexandria:when-let
      ((directory (uiop:truename*
                   (uiop:parse-native-namestring
                    (password::password-directory interface)))))
    (let ((prefix (length (namestring directory))))
      (mapcar (lambda (path)
                (let ((entry (namestring path)))
                  (subseq entry prefix (- (length entry) (length ".age")))))
              (uiop:directory* (format nil "~a/**/*.age" directory))))))

(define-configuration nyxt/mode/password:password-mode
  ((nyxt/mode/password:password-interface (make-instance 'passage-interface))))
