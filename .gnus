(setq gnus-nntp-server "news.eternal-september.org")

(setq gnus-secondary-select-methods '((nnimap "feup"
                                        (nnimap-address "maila.fe.up.pt")
                                        (nnimap-stream ssl)
                                        ;(remove-prefix "INBOX.")
                                        (nnimap-authinfo-file
                                          "/home/jcarlos/.authinfo"))
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
  (setq cursor-type nil)) ; Don't show the cursor

(add-hook 'gnus-summary-mode-hook 'my-setup-hl-line)
(add-hook 'gnus-group-mode-hook 'my-setup-hl-line)

