(defface header1
  '((t (:height 2.0 :foreground "yellow" :bold t)))
  "asd")

(defface header2
  '((t (:height 1.5 :foreground "green" :bold t)))
  "asd")

(defface header3
  '((t (:foreground "cyan" :bold t)))
  "asd")

(defface pragma
  '((t (:foreground "dim gray")))
  "asd")

(defface bullet-list
  '((t (:background "red" :foreground "black")))
  "asd")

(defface numbered-list
  '((t (:background "blue" :foreground "black")))
  "asd")

(defface horizontal-line
  '((t (:foreground "blue")))
  "asd")



(defun find-regex-beginning-of-line (regex)
  "Sees if the regex is in the beginning of the current line, return t if it is or
 nil otherwise."
  (save-excursion
    (beginning-of-line)
    (if (looking-at regex)
      t
      nil)))

;; (defun should-add-new-item-bullet-list ()
;;   "If t it means that we should add the \"  *\" string to the beginning of the next
;; line"
;;   (interactive)
;;   (save-excursion
;;     (beginning-of-line)
;;     (if (looking-at "^  \\*")
;;       t
;;       nil)))

(defun should-add-new-item-bullet-list ()
  (interactive)
  (if (find-regex-beginning-of-line "^  \\*")
    t
    nil))


(defun should-add-new-item-numbered-list ()
  (interactive)
  (if (find-regex-beginning-of-line "^  \\#")
    t
    nil))

(defun new-enter ()
  (interactive)
  (if (should-add-new-item-numbered-list)
    (progn
      (newline)
      (insert "  # "))
    (if (should-add-new-item-bullet-list)
      (progn
        (newline)
        (insert "  * "))
      (newline-and-indent))))
  

(define-derived-mode google-wiki-mode nil "gnome-wiki"
  "Major mode for editing gnome wiki."


  ;; FIXME: This regex doesn't work inside a bulleted list
  (highlight-regexp "\\*\\(.*?\\)\\*" 'bold)
  ;(highlight-regexp "\\*\\(.*?\\)\\*.*?$" 'bold)

  (highlight-regexp "^  \\*" 'bullet-list)
  (highlight-regexp "_\\(.*?\\)_" 'italic)
  (highlight-regexp "=\\(.*?\\)=" 'header1)
  (highlight-regexp "==\\(.*?\\)==" 'header2)
  (highlight-regexp "===\\(.*?\\)===" 'header3)
  (highlight-regexp "^#\\(.*\\)" 'pragma)
  (highlight-regexp "^  \\#" 'numbered-list)
  (highlight-regexp "----" 'horizontal-line)

  (setq truncate-lines nil)

  (local-set-key (kbd "RET") 'new-enter))

(provide 'google-wiki-mode)
