;; mega-simple bbcode mode (font-lock only) by Azundris, 2009/05/10
;; Modified by Rolando, 2009/06/27

(defface strike-throught-face
  '((t (:strike-through t)))
  "asd")

(defface url-face
  '((t (:foreground "cyan" :underline t)))
  "sasf")


(defun bbcode-insert-custom-tag (tag)
  (interactive "sWhat is the tag that you want? ")
  (insert-geral-tag tag))

(defun bbcode-insert-geral-tag (tag)
  (interactive)
  (insert-string (concat "[" tag "][/" tag "]"))
  (backward-char (+ (length tag) 3)))

(defun bbcode-insert-bold-tag ()
  (interactive)
  (insert-geral-tag "b"))

(defun bbcode-insert-italic-tag ()
  (interactive)
  (insert-geral-tag "i"))

(defun bbcode-insert-underline-tag ()
  (interactive)
  (insert-geral-tag "u"))

(defun bbcode-insert-anchor-tag (url)
  (interactive "sWhat is the url? ")
  (insert-geral-tag "url")
  (backward-char)
  (insert "=")
  (unless (zerop (length url))
    (insert url)
    (forward-char)))

(defun bbcode-insert-strike-throught-tag ()
  (interactive)
  (insert-geral-tag "s"))

(defun bbcode-jump-to-end-tag ()
  (interactive)
  (search-forward-regexp "\\[\\/.*\\]"))


(define-derived-mode bbcode-mode nil "BBcode"
  "Major mode for editing bbcode."

  (local-set-key (kbd "C-c b") 'bbcode-insert-bold-tag)
  (local-set-key (kbd "C-c i") 'bbcode-insert-italic-tag)
  (local-set-key (kbd "C-c u") 'bbcode-insert-underline-tag)
  (local-set-key (kbd "C-c c") 'bbcode-insert-custom-tag)
  (local-set-key (kbd "C-c a") 'bbcode-insert-anchor-tag)
  (local-set-key (kbd "C-c s") 'bbcode-insert-strike-throught-tag)
  (local-set-key [tab] 'bbcode-jump-to-end-tag)
  
  (setq truncate-lines nil)

  
  ;; ------------------ FIXME: WHY DOESN'T IT WORK?! -----------------------------
  ;; (defvar sample-font-lock-keywords
  ;;   '(("function \\(\\sw+\\)" (1 font-lock-function-name-face))
  ;;      ("\\[b\\]\\(.*?\\)\\[\\/b\\]" (1 font-lock-function-name-face))
  ;;      ("\\[\\/?\\([^]]+\\)\\]" (1 font-lock-keyword-face))
  ;;      )
  ;;   "sd")

  ;;    ("\\[i\\]\\(.*?\\)\\[\\/i\\]" 'italic)
     
  ;;    ("\\[u\\]\\(.*?\\)\\[\\/u\\]" 'underline)
  ;;    ("\\[s\\]\\(.*?\\)\\[\\/s\\]" 'strike-throught-face)
  ;;    ("\\[quote\\(=[^]]*\\)?\\]\\(.*?\\)\\[\\/quote\\]" 'font-lock-doc-string-face)
  ;;                                       ;(highlight-regexp "\\[url\\(=[^]]*\\)?\\]\\(.*?\\)\\[\\/url\\]" 'font-lock-reference-face)
  ;;    ("\\[url=[^]]*?\\]\\(.*?\\)\\[\\/url\\]" 'url-face))
  ;; "Keyword highlighting specification for `sample-mode'.")

  ;; (set (make-local-variable 'font-lock-defaults)
  ;;   '(sample-font-lock-keywords))
  ;; -----------------------------------------------------------------------------






  ; We place this first so that the [b][/b] and [i][/i] that appear on the text
  ; also become bold or italic
  ; FIXME: Doesn't work if the opening and closing tag are on different lines
  (highlight-regexp "\\[\\/?\\([^]]+\\)\\]" 'font-lock-keyword-face)

  (highlight-regexp "\\[b\\]\\(.*?\\)\\[\\/b\\]" 'bold)
  (highlight-regexp "\\[i\\]\\(.*?\\)\\[\\/i\\]" 'italic)
        
  (highlight-regexp "\\[u\\]\\(.*?\\)\\[\\/u\\]" 'underline)
  (highlight-regexp "\\[s\\]\\(.*?\\)\\[\\/s\\]" 'strike-throught-face)
  (highlight-regexp "\\[quote\\(=[^]]*\\)?\\]\\(.*?\\)\\[\\/quote\\]" 'font-lock-doc-string-face)
  ;(highlight-regexp "\\[url\\(=[^]]*\\)?\\]\\(.*?\\)\\[\\/url\\]" 'font-lock-reference-face)
  (highlight-regexp "\\[url=[^]]*?\\]\\(.*?\\)\\[\\/url\\]" 'url-face)


  ; TODO: There should be a url highlight
  ; TODO: [b][i][/i][/b] should make the text both bold and italic
  ; TODO: There should be a tiny,large,huge, etc. highlight (use macros to create faces?)
  ; TODO: Color tag?
  (highlight-regexp "[\t ]+$" 'whitespace-visual-blank-face)
  (highlight-regexp "[\t]+" 'whitespace-visual-tab-face)


  ;; (setq font-lock-keywords
  ;;                '(
  ;;                  ("\\[\\/?\\([^]]+\\)\\]"      0 font-lock-keyword-face t)
  ;;                  ("\\[i\\]\\(.*?\\)\\[\\/i\\]" 1 italic t)
  ;;                  ("\[b\].*?\[\\b\]" 1 bold t)
  ;;                  ("\\[u\\]\\(.*?\\)\\[\\/u\\]" 1 underline t)
  ;;                  ("\\[quote\\(=[^]]*\\)?\\]\\(.*?\\)\\[\\/quote\\]" 0 font-lock-doc-string-face    t)
  ;;                  ("\\[url\\(=[^]]*\\)?\\]\\(.*?\\)\\[\\/url\\]" 0 font-lock-reference-face    t)

  ;;                  ("[\t ]+$"           0 whitespace-visual-blank-face t)
  ;;                  ("[\t]+"             0 whitespace-visual-tab-face   t)
  ;;                  ))

  )

(provide 'bbcode)
;; ends
