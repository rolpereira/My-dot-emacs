(setq gnus-nntp-server "news.eternal-september.org")

(setq gnus-secondary-select-methods '((nnimap "feup"
                                        (nnimap-address "maila.fe.up.pt")
                                        (nnimap-stream ssl)
                                        ;(remove-prefix "INBOX.")
                                        (nnimap-authinfo-file
                                          "/home/rolando/.authinfo"))
                                       (nntp "news.gmane.org")))


(setq gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f %* %B%s%)\n"
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

(add-hook 'gnus-summary-prepared-hook '(lambda () (setq line-move-visual nil)))

;; TODO: Change hl-line face to underline and foreground and background to nil

;; Automatically jump to the next group
(setq gnus-auto-select-next 'quietly)

;; Don't show articles below this score
(setq-default gnus-summary-expunge-below -1000)

