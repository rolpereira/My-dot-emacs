;; (setq gnus-nntp-server "nntp.aioe.org"
;;       nntp-port-number "563")


(setq gnus-nntp-server "news.eternal-september.org"
  nntp-port-number "563")

(setq gnus-secondary-select-methods '((nnimap "feup"
                                        (nnimap-address "mail.fe.up.pt")
                                        (nnimap-stream ssl)
                                        ;(remove-prefix "INBOX.")
                                        (nnimap-authinfo-file
                                          "/home/rolando/.authinfo"))
                                       (nntp "news.gmane.org")))



(setq gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f %* %B%s%) %k\n"
  gnus-user-date-format-alist '((t . "%d.%m.%Y %H:%M"))
  gnus-sum-thread-tree-false-root ""
  gnus-sum-thread-tree-indent " "
  gnus-sum-thread-tree-root ""
  gnus-sum-thread-tree-leaf-with-other "├► "
  gnus-sum-thread-tree-single-leaf "╰► "
  gnus-sum-thread-tree-vertical "│")

(defun my-setup-hl-line ()
  (hl-line-mode 1)
  (setq cursor-type nil) ; Don't show the cursor
  (visual-line-mode 1))

(add-hook 'gnus-summary-mode-hook 'my-setup-hl-line)
(add-hook 'gnus-group-mode-hook 'my-setup-hl-line)

;; http://www.faqs.org/faqs/gnus-faq
;; Don't show the first article when pressing SPC
(setq gnus-auto-select-first nil)

;; Collapse threads when entering a group
(add-hook 'gnus-summary-prepared-hook 'gnus-summary-hide-all-threads)

;(add-hook 'gnus-summary-prepared-hook '(lambda () (setq line-move-visual nil)))

;; TODO: Change hl-line face to underline and foreground and background to nil

;; Automatically jump to the next group
(setq gnus-auto-select-next 'quietly)

;; Don't show articles below this score
(setq-default gnus-summary-expunge-below -1000)

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; Push the threads with bigger score on top of the buffer
(setq gnus-thread-sort-functions
      '(gnus-thread-sort-by-number
        gnus-thread-sort-by-total-score))

;; (setq gnus-thread-sort-functions
;;            '(gnus-thread-sort-by-number
;;              gnus-thread-sort-by-subject
;;              gnus-thread-sort-by-total-score))

;; (setq gnus-thread-sort-functions
;;            '(gnus-thread-sort-by-number))
;; Configure gnus-demon

;; This version `gnus-demon-scan-news' is exactly like the normal
;; version, but only updates de groups with level 1 (the ones that
;; have higher priority. See (info "(gnus) Group Levels")
(defun gnus-demon-scan-news ()
  (let ((win (current-window-configuration)))
    (unwind-protect
	(save-window-excursion
	  (when (gnus-alive-p)
	    (with-current-buffer gnus-group-buffer
	      (gnus-group-get-new-news 1))))
      (set-window-configuration win))))

(gnus-demon-add-handler 'gnus-demon-scan-news 60 60)

;; Configure gnus-desktop-notification
(require 'gnus-desktop-notify)

(gnus-desktop-notify-mode)

(setq gnus-desktop-notify-groups 'gnus-desktop-notify-explicit)

(setq gnus-desktop-notify-send-program
  "$(mplayer -really-quiet /usr/share/sounds/gnome/default/alerts/drip.ogg > /dev/null &); notify-send -i /usr/share/icons/gnome/32x32/actions/mail_new.png")
;; To let Gnus read atom feeds as rss
;; From: http://www.emacswiki.org/emacs/GnusRss#toc6
(require 'mm-url)
(defadvice mm-url-insert (after DE-convert-atom-to-rss () )
  "Converts atom to RSS by calling xsltproc."
  (when (re-search-forward "xmlns=\"http://www.w3.org/.*/Atom\""
			   nil t)
    (goto-char (point-min))
    (message "Converting Atom to RSS... ")
    (call-process-region (point-min) (point-max)
			 "xsltproc"
			 t t nil
			 (expand-file-name "~/atom2rss.xsl") "-")
    (goto-char (point-min))
    (message "Converting Atom to RSS... done")))

(ad-activate 'mm-url-insert)
(add-hook 'gnus-summary-mode-hook
  (lambda ()
    (local-set-key (kbd "k") 'gnus-summary-kill-same-subject)
    (local-set-key (kbd "C-k") 'gnus-summary-kill-same-subject-and-select)
    ;; I usually prefer to do a very wide reply instead of a reply to a single user

    ;; This used to be "S W". The original function of "R" is now
    ;; called by "r".
    (local-set-key (kbd "R") 'gnus-summary-wide-reply-with-original)

    ;; To call `gnus-summary-reply' (the original function of "r"),
    ;; use "S r".
    (local-set-key (kbd "r") 'gnus-summary-reply-with-original)))
;;; Avoid showing html formated emails since they tend to be displayed with a white background and I can't read them
;;; From: http://www.emacswiki.org/emacs/MimeTypesWithGnus
(setq mm-discouraged-alternatives '("text/html" "text/richtext"))
(add-hook 'gnus-summary-mode-hook
  (lambda ()
    (local-set-key (kbd "k") 'gnus-summary-kill-same-subject)
    (local-set-key (kbd "C-k") 'gnus-summary-kill-same-subject-and-select)
    ;; I usually prefer to do a very wide reply instead of a reply to a single user

    ;; This used to be "S W". The original function of "R" is now
    ;; called by "r".
    (local-set-key (kbd "R") 'gnus-summary-wide-reply-with-original)

    ;; To call `gnus-summary-reply' (the original function of "r"),
    ;; use "S r".
    (local-set-key (kbd "r") 'gnus-summary-reply-with-original)))
