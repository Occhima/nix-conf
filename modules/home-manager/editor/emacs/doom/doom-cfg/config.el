;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Marco Occhialini"
      base-dir "~/Dropbox"
      user-mail-address "marcoocchialini@usp.br"
      command-line-default-directory "~/"
      delete-by-moving-to-trash t
      custom-file (expand-file-name "custom.el" doom-cache-dir)
      +lookup-provider-url-alist
      '(("Doom Emacs issues" "https://github.com/doomemacs/doomemacs/issues?q=is%%3Aissue+%s")
        ("DuckDuckGo" +lookup--online-backend-duckduckgo "https://duckduckgo.com/?q=%s")
        ("StackOverflow" "https://stackoverflow.com/search?q=%s")
        ("GitHub" "https://github.com/search?ref=simplesearch&q=%s")
        ("YouTube" "https://youtube.com/results?aq=f&oq=&search_query=%s")
        ("MDN" "https://developer.mozilla.org/en-US/search?q=%s")
        ("Arch Wiki" "https://wiki.archlinux.org/index.php?search=%s&title=Special%3ASearch&wprov=acrw1")
        ("AUR" "https://aur.archlinux.org/packages?O=0&K=%s"))
      trash-directory "~/.local/share/Trash/files")

(dolist (file '("+ui" "+functions" "+prog" "+org" "+academic" "+apps" "+ai"))
  (load! (concat "elisp/" file)))
