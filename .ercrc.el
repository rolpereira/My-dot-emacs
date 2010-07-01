;; Nicks de varias cores
(require 'erc-nick-colors)

;; Spellchecking
(erc-spelling-mode 1)

(setq erc-spelling-dictionaries '(("irc.ptnet.org:6667" "portugues")
                                   ("irc.freenode.net:6667" "english")))

;; ;; Highlight de palavras
;; (require 'erc-match)
;; (setq erc-keywords '("rolando" "rolando2424"))
;; (erc-match-mode)
;; ;; Tocar um som ao encontrar o nick
;; (add-hook 'erc-text-matched-hook
;;           (lambda (match-type nickuserhost message)
;;             (cond
;;               ((eq match-type 'current-nick)
;;                 (play-sound-file "~/pub/TR2070/TR-Mail.wav"))
;;               ((eq match-type 'keyword)
;;                 (play-sound-file "~/pub/TR2070/TR-Command.wav")))))

;; Lista de canais a fazer auto-join
(setq erc-autojoin-channels-alist
  '(("freenode.net" "#emacs"); "#haskell" "#python" "#xmonad")
      ;"#pygame" ;"#latex") ;"#debian")
     ("ptnet.org" "#p@p")
     ("efnet.org" "#gccg")))
;; (erc :server "irc.freenode.net" :port 6667 :nick "rolando")
;; (erc :server "irc.ptnet.org" :port 6667 :nick "rolando2424")
;; (erc :server "irc.efnet.org" :port 6667 :nick "rolando")

(defun rolando-open-erc-ptnet (server)
  (interactive "sWhich server do you wish to connect: ")
  (if (string= server "irc.ptnet.org")
    (erc :server server :port 6667 :nick "rolando2424"
      :password (read-passwd "Password: "))))

;; O Prompt fica com o nome do canal
(setq erc-prompt
  (lambda ()
    (if (and (boundp 'erc-default-recipients) (erc-default-target))
      (erc-propertize (concat (erc-default-target) ">")
        'read-only t 'rear-nonsticky t 'front-nonsticky t)
      (erc-propertize (concat "ERC>")
        'read-only t 'rear-nonsticky t 'front-nonsticky t))))

;; Mudar o charset
(setq erc-server-coding-system '(iso-8859-1 . iso-8859-1))
;(setq erc-server-coding-system '(utf-8 . utf-8))

;; ;; Transformar links em butoes que abrem o browser
;; (setq erc-button-url-regexp
;;   "\\([-a-zA-Z0-9_=!?#$@~`%&*+\\/:;,]+\\.\\)+[-a-zA-Z0-9_=!?#$@~`%&*+\\/:;,]*[-a-zA-Z0-9\\/]")

;; logging:
;; http://www.emacswiki.org/emacs/ErcExampleEmacsFile
(setq erc-log-insert-log-on-open nil)
(setq erc-log-channels t)
(setq erc-log-channels-directory "~/.irclogs/")
(setq erc-save-buffer-on-part t)
(setq erc-hide-timestamps nil)

;; (defadvice save-buffers-kill-emacs (before save-logs (arg) activate)
;;   (save-some-buffers t (lambda () (when (and (eq major-mode 'erc-mode)
;;                                              (not (null buffer-file-name)))))))

(add-hook 'erc-insert-post-hook 'erc-save-buffer-in-logs)
(add-hook 'erc-mode-hook '(lambda () (when (not (featurep 'xemacs))
                                       (set (make-variable-buffer-local
                                             'coding-system-for-write)
                                            'emacs-mule))))
;; end logging

(require 'erc-track)
(eval-after-load 'erc-track
  '(progn
     (defun erc-bar-move-back (n)
       "Moves back n message lines. Ignores wrapping, and server messages."
       (interactive "nHow many lines ? ")
       (re-search-backward "^.*<.*>" nil t n))

     (defun erc-bar-update-overlay ()
       "Update the overlay for current buffer, based on the content of
erc-modified-channels-alist. Should be executed on window change."
       (interactive)
       (let* ((info (assq (current-buffer) erc-modified-channels-alist))
               (count (cadr info)))
         (if (and info (> count erc-bar-threshold))
           (save-excursion
             (end-of-buffer)
             (when (erc-bar-move-back count)
               (let ((inhibit-field-text-motion t))
                 (move-overlay erc-bar-overlay
                   (line-beginning-position)
                   (line-end-position)
                   (current-buffer)))))
           (delete-overlay erc-bar-overlay))))

     (defvar erc-bar-threshold 1
       "Display bar when there are more than erc-bar-threshold unread messages.")
     (defvar erc-bar-overlay nil
       "Overlay used to set bar")
     (setq erc-bar-overlay (make-overlay 0 0))
     (overlay-put erc-bar-overlay 'face '(:underline "red"))
     ;;put the hook before erc-modified-channels-update
     (defadvice erc-track-mode (after erc-bar-setup-hook
                                 (&rest args) activate)
       ;;remove and add, so we know it's in the first place
       (remove-hook 'window-configuration-change-hook 'erc-bar-update-overlay)
       (add-hook 'window-configuration-change-hook 'erc-bar-update-overlay))
     (add-hook 'erc-send-completed-hook (lambda (str)
                                          (erc-bar-update-overlay)))))

(require 'erc-nick-notify)


(defun erc-cmd-UPTIME (&rest ignore)
  "Display the uptime of the system, as well as some load-related
stuff, to the current ERC buffer."
  (let ((uname-output
         (replace-regexp-in-string
          ", load average: " "] {Load average} ["
          ;; Collapse spaces, remove
          (replace-regexp-in-string
           " +" " "
           ;; Remove beginning and trailing whitespace
           (replace-regexp-in-string
            "^ +\\|[ \n]+$" ""
            (shell-command-to-string "uptime"))))))
    (erc-send-message
     (concat "{Uptime} [" uname-output "]"))))

(defun erc-cmd-UNAME (&rest ignore)
  "Display the result of running `uname -a' to the current ERC
buffer."
  (let ((uname-output
         (replace-regexp-in-string
          "[ \n]+$" "" (shell-command-to-string "uname -a"))))
    (erc-send-message
     (concat "{uname -a} [" uname-output "]"))))

(defun erc-cmd-HOWMANY (&rest ignore)
  "Display how many users (and ops) the current channel has."
  (erc-display-message nil 'notice (current-buffer)
    (let ((hash-table (with-current-buffer
                        (erc-server-buffer)
                        erc-server-users))
           (users 0)
           (ops 0))
      (maphash (lambda (k v)
                 (when (member (current-buffer)
                         (erc-server-user-buffers v))
                   (incf users))
                 (when (erc-channel-user-op-p k)
                   (incf ops)))
        hash-table)
      (format
        "There are %s users (%s ops) on the current channel"
        users ops))))

;; Interpret mIRC-style color commands in IRC chats
(setq erc-interpret-mirc-color t)

;; The following are commented out by default, but users of other
;; non-Emacs IRC clients might find them useful.
;; Kill buffers for channels after /part
(setq erc-kill-buffer-on-part t)
;; Kill buffers for private queries after quitting the server
(setq erc-kill-queries-on-quit t)
;; Kill buffers for server messages after quitting the server
(setq erc-kill-server-buffer-on-quit t)

(setq erc-timestamp-format "[%H:%M] ")
(setq erc-fill-prefix "      + ")

;(setq erc-encoding-coding-alist (quote (("#lisp" . utf-8)
;          ("#nihongo" . iso-2022-jp) ("#truelambda" . iso-latin-1)
;          ("#bitlbee" . iso-latin-1))))
