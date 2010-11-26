; Time-stamp: <2010-09-14 10:21:00 (rolando)>

;; TODO: Arranjar uma keybind para find-function (podera funcionar melhor que as tags)

(defvar *emacs-load-start* (current-time))


; Experimentar usar a variavel default-directory

(defun Where-Am-i ()
  "If it returns t, then I am on the laptop, otherwise I am on the desktop."
  (let ((LAPTOP-HOSTNAME "rolando-laptop")
          (DESKTOP-HOSTNAME "rolando-desktop"))
    (cond ((string= system-name LAPTOP-HOSTNAME)
            'laptop)
      ((string= system-name DESKTOP-HOSTNAME)
        'desktop)
      (t
        'undefined))))

(defun Are-We-On-Windows ()
  (if (equal system-type 'windows-nt)
      t
    nil))

(defconst iamwindows (Are-We-On-Windows)
  "If t, then we are on a windows system, otherwise se assume we are in a linux system")

(defconst whereami (Where-Am-i)
  "If 'laptop, then we are on the laptop and in the linux system.
If 'desktop, then we are on the desktop system and in the linux system.
If 'undefined, then we don't know where we are.")

(if (not iamwindows)
  (server-start))

;; Idea from http://nflath.com/2009/07/more-random-emacs-config/
(defun rolando-back-to-indentation-or-move-beginning-of-line ()
  "Moves to the first caracter in the line, unless it's in it, in that case
it moves the cursor to the beginning-of-line"
  (interactive)
  (let ((current-point (point)))
    (back-to-indentation)
    (if (= current-point (point))
      (move-beginning-of-line nil))))

(global-set-key (kbd "C-a") 'rolando-back-to-indentation-or-move-beginning-of-line)
(global-set-key (kbd "<home>") 'rolando-back-to-indentation-or-move-beginning-of-line)



(defun set-home-folder ()
  (cond ((and (equal whereami 'laptop) (not iamwindows))
          ;"/media/JCARLOS/")
         "/home/rolando/")
    (iamwindows
      (substring default-directory 0 -9))
    ((equal whereami 'desktop)
      "/home/rolando/")))

;(message (file-name-directory load-file-name))

(defconst home (concat (set-home-folder) ".emacs.d/"))
;(defconst home (file-name-directory load-file-name))

(defun file-in-exec-path-p (filename)
  "Returns t if FILENAME is in the system exec-path, otherwise returns nil"
  (if (locate-file filename exec-path)
    t
    nil))




;; E necessario muitas vezes
(with-no-warnings 
  (require 'cl))

; Load Emacs Code Browser
;; (add-to-list 'load-path (concat home ".emacs.d/elisp/ecb-snap"))
;; (require 'ecb)


(setq eldoc-idle-delay 0)

(setq visible-bell t)

(add-to-list 'load-path (concat home "elisp"))
(add-to-list 'load-path (concat home "elpa"))

;; Activate packages installed using package.el
(load "package")
(package-initialize)


;; (if iamlaptop
;;     (add-to-list 'load-path (concat "/media/JCARLOS/.emacs.d/elisp"))
;;   (add-to-list 'load-path (concat
;; ;; (if iamlaptop
;; ;;   (setq load-path (append '("/media/JCARLOS/.emacs.d/elisp") load-path))
;; ;;   (setq load-path (append '("~/.emacs.d/elisp") load-path)))

(setq load-path (append '("/usr/share/emacs/site-lisp/pydb") load-path))
(setq c-default-style "bsd")



(message "Stop 1 %ds" (destructuring-bind (hi lo ms) (current-time)
                           (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))



(setq require-final-newline t)                ; Always newline at end of file

; Mostrar os espacos vazios no final das linhas
; FIXME: This should only be on the programming mode
(setq show-trailing-whitespace t)

(when window-system
  (global-unset-key "\C-z"))            ; iconify-or-deiconify-frame (C-x C-z)

(setq-default ispell-program-name "aspell") ; Use aspell instead of ispell
(setq ispell-dictionary "portugues")             ; Set ispell dictionary

(setq frame-title-format "%b - emacs")
; Tabs colocam 4 espacos
(setq-default c-basic-offset 4
  tab-width 4
  indent-tabs-mode nil)
(setq backward-delete-char-untabify nil
  tab-width 4)
;;;

; Coisas SVN
(load "psvn.el")
;;

;Alguns modos precisam disto
(setq user-mail-address "finalyugi@sapo.pt"
  user-full-name "Rolando Pereira")
;;;

; Activar Org-Mode
(setq load-path (cons (concat home "elisp/org-6.31a/lisp") load-path))
(setq load-path (cons (concat home "elisp/org-6.31a/contrib/lisp") load-path))
;;;;;

; Mostra so a * mais a direita no org-mode
(setq org-hide-leading-stars t)
;;;

;; The following lines are always needed. Choose your own keys.
;; (Configuracoes do Org-Mode)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;;;;;

; Activar flymake-mode para o python usando o pyflakes
(when (and (load "flymake" t) (file-in-exec-path-p "pyflakes"))
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                        'flymake-create-temp-inplace))
            (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))

   (add-to-list 'flymake-allowed-file-name-masks
     '("\\.py\\'" flymake-pyflakes-init)))

;; FIXME: flymake-find-file-hook should be used only if there is a makefile
;(add-hook 'find-file-hook 'flymake-find-file-hook)
;;;

; Flymake settings
(defun my-flymake-show-next-error()
  (interactive)
  (flymake-goto-next-error)
  (flymake-display-err-menu-for-current-line))

(global-set-key [f8] 'my-flymake-show-next-error)
;; '(flymake-errline ((((class color)) (:underline "OrangeRed"))))
;; '(flymake-warnline ((((class color)) (:underline "yellow"))))


; Activar folding no Python
(defun my-python-mode-hook ()
  (hs-minor-mode 1)
  (eldoc-mode 1)
  '(lambda ()
     (local-set-key (kbd "RET") 'newline-and-indent)))

(add-hook 'python-mode-hook 'my-python-mode-hook)

;; C/C++/Java/C# Mode
(defun my-c-mode-common-hook ()
  (setq show-paren-style 'parenthesis)
  ;(setq c-hungry-delete-key t)
  ;(setq c-auto-newline 1)
  (highlight-fixmes-mode)
  (hs-minor-mode)
;  (lambda ()
 ;   (font-lock-add-keywords nil
  ;    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t))))
  ;(flymake-mode t)
  ;(yas/minor-mode)

  ;; Show line numbers
  (linum-mode)
  )

(message "Stop 2 %ds" (destructuring-bind (hi lo ms) (current-time)
                           (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))





(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

; Mudar a theme do emacs
(when window-system
  (require 'color-theme)
  ;(require 'color-theme-tango)
  (require 'zenburn)
  (require 'color-theme-dark-bliss)
  ;(require 'color-theme-sunburst)
  (color-theme-initialize)
  ;(color-theme-charcoal-black))
  ;(color-theme-taming-mr-arneson))
;  (color-theme-goldenrod)
  ;(color-theme-tango))
  ;(color-theme-zenburn))
  ;(color-theme-sunburst))
  ;(color-theme-taylor))
                                        ;(color-theme-dark-bliss)
  (color-theme-midnight))
; Other themes: midnight, white on black, charcoal black, Calm Forest, Billw,
; Arjen, Clarity and Beauty, Cooper Dark, Comidia, Dark Blue 2, Dark Laptop,
; Deep Blue, Hober, Late Night, Lethe, Linh Dang Dark, Taming Mr Arneson,
; Subtle Hacker, TTY Dark, Taylor,  White On Black, Robin Hood
;;;

; Add colors to shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;

;; zooming in and zooming out in emacs like in firefox
;; zooming; inspired by http://blog.febuiles.com/page/2/
(defun djcb-zoom (n) (interactive)
  (set-face-attribute 'default (selected-frame) :height
    (+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10))))

(global-set-key (kbd "C-+")      '(lambda()(interactive(djcb-zoom 1))))
(global-set-key [C-kp-add]       '(lambda()(interactive(djcb-zoom 1))))
(global-set-key (kbd "C--")      '(lambda()(interactive(djcb-zoom -1))))
(global-set-key [C-kp-subtract]  '(lambda()(interactive(djcb-zoom -1))))

(global-set-key [(control tab)] 'ffap)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; time-stamps
;; when there is a "Time-stamp: <>" in the first 10 lines of the file,
;; emacs will write time-stamp information there when saving the file.
;; see the top of this file for an example...
(setq
  time-stamp-active t          ; do enable time-stamps
  time-stamp-line-limit 10     ; check first 10 buffer lines for Time-stamp: <>
  time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)") ; date format
(add-hook 'write-file-hooks 'time-stamp) ; update when saving
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; turn on autofill for all text-related modes
(toggle-text-mode-auto-fill)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elisp

(defun djcb-emacs-lisp-mode-hook ()
  (interactive)

  ;; overrides the global f7 for compilation
  (local-set-key (kbd "<f7>") 'eval-buffer)

  (set-input-method nil)       ; i don't want accented chars, funny "a etc.
  (setq lisp-indent-offset 2)  ; indent with two spaces, enough for lisp

  (font-lock-add-keywords nil
    '(("\\<\\(FIXME\\|TODO\\|XXX+\\|BUG\\):"
        1 font-lock-warning-face prepend)))

  (font-lock-add-keywords nil
    '(("\\<\\(require-maybe\\|add-hook\\|setq\\)"
        1 font-lock-keyword-face prepend)))

  (show-paren-mode 1)
  (setq show-paren-style 'expression)
  (eldoc-mode 1))

(add-hook 'emacs-lisp-mode-hook 'djcb-emacs-lisp-mode-hook)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(message "Stop 3 %ds" (destructuring-bind (hi lo ms) (current-time)
                           (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; backups  (emacs will write backups and number them)
(setq make-backup-files t ; do make backups
  backup-by-copying t ; and copy them ...
  backup-directory-alist '(("." . "~/.emacs.d/backup/")) ; ... here
  version-control t
  kept-new-versions 2
  kept-old-versions 5
  delete-old-versions t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Activar winner
(winner-mode 1)
;;;

; Colocar o text-mode como default ao abrir um ficheiro e fazer com que o o
; texto so tenha 78 caracteres de largura
(setq-default major-mode 'text-mode)
(setq fill-column 78)
(auto-fill-mode t)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;;;

; Indicar o tamanho do ficheiro
(size-indication-mode t)
;;;

;; W3m configurations
(add-to-list 'load-path (concat home "elisp/emacs-w3m"))
(autoload 'w3m "w3m" "" t)
(eval-after-load "w3m"
  '(when (not (Are-We-On-Windows)) ; Can't use W3m in Windows
     ;; (cond ((= emacs-major-version 23)
     ;;         (add-to-list 'load-path (concat home "elisp/emacs-w3m"))
     ;;         ;;    (require 'w3m-load)
     ;;         ))

     (require 'w3m)
     (setq browse-url-browser-function 'w3m-browse-url)
     (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
     (setq w3m-use-cookies t)

     ;; Mudar keybinding
     (eval-after-load 'w3m
       '(progn
          (define-key w3m-mode-map "q" 'w3m-previous-buffer)
          (define-key w3m-mode-map "w" 'w3m-next-buffer)
          (define-key w3m-mode-map "x" 'w3m-delete-buffer)))

     ;; Gravar sessions
     ;; (cond ((= emacs-major-version 22)
     (require 'w3m-session)
     (setq w3m-session-file "~/.emacs.d/w3m-session")
     (setq w3m-session-save-always t)
     (setq w3m-session-load-always t)
     (setq w3m-session-autosave-period 30)
     (setq w3m-session-duplicate-tabs 'always)

     ; Load last sessions
     (setq w3m-session-load-last-sessions t)

     ;; Utitilizar numeros para saltar para links
     ;; http://emacs.wordpress.com/2008/04/12/numbered-links-in-emacs-w3m/
     (require 'w3m-lnum)
     (defun jao-w3m-go-to-linknum ()
       "Turn on link numbers and ask for one to go to."
       (interactive)
       (let ((active w3m-link-numbering-mode))
         (when (not active) (w3m-link-numbering-mode))
         (unwind-protect
           (w3m-move-numbered-anchor (read-number "Anchor number: "))
           (when (not active) (w3m-link-numbering-mode)))))

     (define-key w3m-mode-map "f" 'jao-w3m-go-to-linknum)

     ;; Use sessions on w3m (from Emacs Wiki)

     (require 'w3m-session)

     (define-key w3m-mode-map "S" 'w3m-session-save)
     (define-key w3m-mode-map "L" 'w3m-session-load)
     (define-key w3m-mode-map (kbd "C-j") 'w3m-search)

     ;; Download youtube video at point
     (defun w3m-yt-view ()
       "View a YouTube link with mplayer."
       (interactive)
       (let ((url (or (w3m-anchor) (w3m-image))))
         (cond ((string-match "youtube" url)
                 (string-match "[^v]*v.\\([^&]*\\)" url)
                 (let* ((vid (match-string 1 url))
                         (info (with-temp-buffer
                                 (w3m-retrieve
                                   (format "http://www.youtube.com/get_video_info?video_id=%s"
                                     vid))
                                 (buffer-string))))
                   (string-match "&token=\\([^%]*\\)" info)
                   (let ((vurl (format "http://www.youtube.com/get_video?video_id=%s&t=%s=&fmt=18"
                                 vid
                                 (match-string 1 info))))
                     (start-process "mplayer" nil "mplayer" "-quiet" "-cache" " 8192"
                       (nth 5 (w3m-attributes vurl))))))
           (t
             (message "Not yt URL.")))))
     ))
;;;;

;; ;Activar o AUCTeX
(setq load-path (cons (concat home "elisp/auctex-11.85/") load-path))
(setq load-path (cons (concat home "elisp/auctex-11.85/preview/") load-path))
(require 'tex-site)
(load "preview-latex.el" nil t t)
;; ;;;;;

;; spellcheck in LaTex mode
(add-hook 'latex-mode-hook 'flyspell-mode)
(add-hook 'tex-mode-hook 'flyspell-mode)
(add-hook 'bibtex-mode-hook 'flyspell-mode)
;;;;;



(message "Stop 4 %ds" (destructuring-bind (hi lo ms) (current-time)
                        (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))




                                        ; Dias do calendario traduzidos para PT
(setq calendar-date-style 'european)
(setq calendar-week-start-day 1
  calendar-day-name-array
  ["Domingo" "Segunda" "Terça"
    "Quarta" "Quinta" "Sexta" "Sábado"]
  calendar-month-name-array
  ["Janeiro" "Fevereiro" "Março" "Abril"
    "Maio" "Junho" "Julho" "Agosto" "Setembro"
    "Outubro" "Novembro" "Dezembro"])
;;;;;

                                        ; Colocar o calendario mais bonito
(setq calendar-view-diary-initially-flag t
  calendar-mark-diary-entries-flag t
  number-of-diary-entries 7)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)
;;;;;

                                        ; Mostrar imagens do site icanhascheezburger.com
(autoload 'cheezburger "cheezburger" "" t)
;;;;;

                                        ; Fazer highline das palavras TODO e FIXME, entre outras
(autoload 'highlight-fixmes-mode "highlight-fixmes-mode" "" t)
;; FIXME: Add this to programming hooks
                                        ;(highlight-fixmes-mode t)
;;;

;; Show line-number and column-number in the mode line
(line-number-mode 1)
(column-number-mode 1)
;;;;;

;; Activar font-lock mode para todos os buffers
(global-font-lock-mode 1)
;;;;;

;; ============================
;; Setup syntax, background, and foreground coloring
;; ============================
(setq font-lock-maximum-decoration t)
;;;;;
;; ============================

;; ============================
;; Key mappings
;; ============================

;; use F1 key to go to a man page
(global-set-key [f1] 'man)
;; use F3 key to kill current buffer
(global-set-key [f3] 'kill-this-buffer)
;; use F5 to get help (apropos)
(global-set-key [f5] 'apropos)
;; use F6 to kill current buffer and window
(global-set-key [f6] 'kill-buffer-and-window)
;; ============================

;; ============================
;; Mouse Settings
;; ============================

;; mouse button one drags the scroll bar
(global-set-key [vertical-scroll-bar down-mouse-1] 'scroll-bar-drag)
;; ============================

;; ============================
;; DisplaY
;; ============================

;; setup font
;; This ones don't work on Windows
(if (not (Are-We-On-Windows))
  (if (= emacs-major-version 23)
                                        ;(set-default-font "Bitstream Vera Sans Mono-12")
    (set-frame-font "Inconsolata 14")
    (set-frame-font
      "-adobe-courier-medium-r-normal-*-14-100-*-*-*-*-iso10646-1"))
  (set-frame-font "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso8859-1"))

                                        ; Mostrar linhas lado esquerdo

(add-hook 'emacs-lisp-mode-hook 'linum-mode)
(add-hook 'python-mode-hook 'linum-mode)
(add-hook 'haskell-mode-hook 'linum-mode)

(global-set-key (kbd "<f2>") 'linum-mode)
;;;




(message "Stop 5 %ds" (destructuring-bind (hi lo ms) (current-time)
                        (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))




;; display the current time
(setq display-time-24hr-format t)
(display-time)

;; alias y to yes and n to no
(defalias 'yes-or-no-p 'y-or-n-p)

;; highlight matches from searches
(setq isearch-highlight t
  search-highlight t)
(setq-default transient-mark-mode t)

;; Cursor should not blink
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))
;; ===========================

;; ===========================
;; Behaviour
;; ===========================

                                        ; See the commands I'm writing
(setq echo-keystrokes 0.1)

;; Pgup/dn will return exactly to the starting point.
(setq scroll-preserve-screen-position 1)

                                        ;Define mnemonic key bindings for moving to 'M-x compile' and 'M-x grep' matches
(global-set-key "\C-cn" 'next-error)
(global-set-key "\C-cp" 'previous-error)

                                        ; Don't bother entering search and replace args if the buffer is read-only
(defadvice query-replace-read-args (before barf-if-buffer-read-only activate)
  "Signal a 'buffer-read-only' error if the current buffer is read-only."
  (barf-if-buffer-read-only))

;; scroll just one line when hitting the bottom of the window
(setq scroll-step 1)
(setq scroll-conservatively 1)

;; show a menu only when running within X (save real estate when
;; in console)
                                        ;(menu-bar-mode (if window-system 1 -1))

;; resize the mini-buffer when necessary
(setq resize-minibuffer-mode t)

;; highlight during searching
(setq query-replace-highlight t)
;; ===============================

;; ===========================
;; HTML/CSS stuff
;; ===========================

;; take any buffer and turn it into an html file,
;; including syntax hightlighting
(require 'htmlize)

;; ===========================

;; ===========================
;; Custom Functions
;; ===========================
                                        ; resize man page to take up whole screen
(setq Man-notify 'bully)
;;

                                        ; SSH, etc.
(require 'tramp)
(setq tramp-default-method "telnet")
(setq tramp-debug-buffer t)
(setq tramp-verbose 10)
                                        ; host + user > proxy
;; (add-to-list 'tramp-default-proxies-alist
;;   '("\\." nil "/telnet:ei08150@tcpgate.fe.up.pt:"))
;; (add-to-list 'tramp-default-proxies-alist
;;   '("\\.riff\\.fe\\.up\\.pt\\'" nil nil))
                                        ; Aceder ao site da sapo
(setenv "SITE" "/ftp:rolando.do.sapo.pt@ftp.homepages.sapo.pt:~")
;;

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
  (concat "~/.emacs.d/autosaves/" (user-login-name) "/"))

(make-directory autosave-dir t)





(message "Stop 6 %ds" (destructuring-bind (hi lo ms) (current-time)
                        (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))






(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
    (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
      (expand-file-name
        (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "~/.emacs.d/backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Auto-Completation on files
;; http://emacs-fu.blogspot.com/2009/02/switching-buffers.html
(ido-mode t)                         ; for both buffers and files
(setq
  ido-ignore-buffers                 ; ignore these guys
  '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "\*scratch\*")
                                        ;  ido-work-directory-list '("~/" "~/Desktop")
  ido-case-fold  t                   ; be case-insensitive
                                        ;  ido-use-filename-at-point nil      ; don't use filename at point (annoying)
                                        ;  ido-use-url-at-point nil           ;  don't use url at point (annoying)
  ido-enable-flex-matching t         ; be flexible
                                        ;  ido-max-prospects 10               ; don't spam my minibuffer
                                        ;  ido-confirm-unique-completion t ; wait for RET, even with unique completion
  ido-create-new-buffer 'always) ; I'm always creating new buffers


                                        ; Saltar para onde se estava quando abrir um ficheiro
(require 'saveplace)
(setq-default save-place t)
;;;;;

                                        ; Cursor do rato nao cobre o texto
(mouse-avoidance-mode 'jump)
;;;;;

                                        ; Yasnippet
(add-to-list 'load-path (concat home "plugins/yasnippet"))
(load "yasnippet.el") ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory (concat home "plugins/yasnippet/snippets"))
;;;;;

                                        ; Remove splash screen
(setq inhibit-splash-screen t)
;;;

                                        ; Enter faz automaticamente o indent do codigo
                                        ;(define-key global-map (kbd "RET") 'newline-and-indent)
;;;

                                        ; Detaching the custom-file
                                        ; http://www.emacsblog.org/2008/12/06/quick-tip-detaching-the-custom-file/
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
;;;


(defun djcb-term-start-or-switch (prg &optional use-existing)
  "* run program PRG in a terminal buffer. If USE-EXISTING is non-nil
   and PRG is already running, switch to that buffer instead of starting
   a new instance."
  (interactive)
  (let ((bufname (concat "*" prg "*")))
    (when (not (and use-existing
                 (let ((buf (get-buffer bufname)))
                   (and buf (buffer-name (switch-to-buffer bufname))))))
      (ansi-term prg prg))))

(defmacro djcb-program-shortcut (name key &optional use-existing)
  "* macro to create a key binding KEY to start some terminal program PRG;
    if USE-EXISTING is true, try to switch to an existing buffer"
  `(global-set-key ,key
     '(lambda()
        (interactive)
        (djcb-term-start-or-switch ,name ,use-existing))))

;; terminal programs are under Shift + Function Key
(djcb-program-shortcut "zsh"   (kbd "<S-f1>") t)  ; the ubershell
(djcb-program-shortcut "mutt"  (kbd "<S-f2>") t)  ; mail client
(djcb-program-shortcut "slrn"  (kbd "<S-f3>") t)  ; nttp client
(djcb-program-shortcut "htop"  (kbd "<S-f4>") t)  ; my processes
(djcb-program-shortcut "mc"    (kbd "<S-f5>") t)  ; midnight commander
(djcb-program-shortcut "raggle"(kbd "<S-f6>") t)  ; rss feed reader
(djcb-program-shortcut "irssi" (kbd "<S-f7>") t)  ; irc client
(djcb-program-shortcut "tt++ " (kbd "<S-f8>") t)  ; MUD client
;;;;;;;;


(message "Stop 7 %ds" (destructuring-bind (hi lo ms) (current-time)
                        (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))



;; Mover para as janelas usando o ALT+setas
;; http://www.emacsblog.org/2008/05/01/quick-tip-easier-window-switching-in-emacs/
(windmove-default-keybindings 'meta)
;;


(message "Stop 8 %ds" (destructuring-bind (hi lo ms) (current-time)
                        (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))


;; Load bookmarks
;; http://www.emacsblog.org/2007/03/22/bookmark-mania/
(load "bm-1.34.el")
(setq bm-restore-repository-on-load t)
;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)

;; Loading the repository from file when on start up.
(add-hook' after-init-hook 'bm-repository-load)

;; Restoring bookmarks when on file find.
(add-hook 'find-file-hooks 'bm-buffer-restore)

;; Saving bookmark data on killing a buffer
(add-hook 'kill-buffer-hook 'bm-buffer-save)


(message "Stop 9 %ds" (destructuring-bind (hi lo ms) (current-time)
                        (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))



;; Saving the repository to file when on exit.
;; kill-buffer-hook is not called when emacs is killed, so we
;; must save all bookmarks first.
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))
(global-set-key (kbd "<C-f4>") 'bm-toggle)
(global-set-key (kbd "<f4>")   'bm-next)
(global-set-key (kbd "<S-f4>") 'bm-previous)
;;;;;;;;;;;;;

;; Need to find some keybindings for the laptop
(require 'fold-dwim)
(if (equal whereami 'laptop)
  (progn
    (global-set-key [(C J)] 'fold-dwim-hide-all)
    (global-set-key [(C K)] 'fold-dwim-toggle)
    (global-set-key [(C L)] 'fold-dwim-show-all))
  ;; On the numpad
  (global-set-key [(C kp-left)] 'fold-dwim-hide-all)   ; Key 4
  (global-set-key [(C kp-begin)] 'fold-dwim-toggle)    ; Key 5
  (global-set-key [(C kp-right)] 'fold-dwim-show-all)) ; Key 6


;; % igual ao Vim
;; http://mewde.blogspot.com/2007_05_01_archive.html
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
    ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
    (t (self-insert-command (or arg 1)))))
;;;;;

;; Fazer perguntas sobre keybindings
;; http://mewde.blogspot.com/2007_05_01_archive.html
(autoload 'keywiz "keywiz" "" t)
;;

;; ;; Scheme Mode
;; (defun rolando-scheme-send-whole-buffer ()
;;   "Sends the entire buffer to the inferior scheme process"
;;   (interactive)
;;   (save-excursion
;;     (set-buffer "*scheme*")
;;     (erase-buffer)
;;     (save-excursion
;;       (scheme-send-region (point-min) (point-max))
;;       (if (get-buffer-window "*scheme*")
;;         (display-buffer "*scheme*" t))
;;       (unless (get-buffer-window "*scheme*")
;;         (split-window-vertically)
;;         (windmove-do-window-select 'down)
;;         (set-window-buffer (selected-window) "*scheme*")))))

;; (defun rolando-scheme-mode-hook ()
;;   (interactive)
;;   (local-set-key (kbd "C-t") 'rolando-scheme-send-whole-buffer))

;; (add-hook 'scheme-mode-hook 'rolando-scheme-mode-hook)
;; ;;;;

;; F20 = Right Windows key
(defun rolando-switch-buffer ()
  "Alternates buffers like GNU Screen and Ratpoison"
  (interactive)
  (switch-to-buffer (other-buffer)))
(global-set-key [f20] 'rolando-switch-buffer)
;;

(defun rolando-complete-python-symbol (symbol)
  "Show the documentation for the python symbol on the cursor on a resized frame"
  (interactive)

  ;; (interactive
  ;;   (let ((symbol (with-syntax-table python-dotty-syntax-table
  ;;                   (current-word)))
  ;;          (enable-recursive-minibuffers t))
  ;;     (list (read-string (if symbol
  ;;                          (format "Describe symbol (default %s): " symbol)
  ;;                          "Describe symbol: ")
  ;;             nil nil symbol))))



  (message "Stop 10 %ds" (destructuring-bind (hi lo ms) (current-time)
                           (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))


                                        ; Usar o fit-window-to-buffer, display-buffer
  (let ((name "*Python Documentation*"))
    (save-excursion
                                        ;    (python-describe-symbol symbol) ; Cria um buffer com o nome *Help*
      (get-buffer-create name)
      (set-buffer name)
      (save-excursion
        (display-buffer name)
        (select-window (next-window))
        (fit-window-to-buffer (selected-window) 10 4)))))

;; Automatically close the compilation buffer after a successful compilation
;; http://www.emacswiki.org/emacs/ModeCompile
(defun compile-autoclose (buffer string)
  (cond ((and (string-match "finished" string)
           (string= (buffer-name) "*compilation*")) ; No need to hide buffer *grep* or *find*
          (bury-buffer "*compilation*")
          (winner-undo)
          (message "Build successful."))
    (t
      (message "Compilation exited abnormally: %s" string))))
(setq compilation-finish-functions 'compile-autoclose)
;;

;; Quick compile
(global-set-key [f11] 'compile)
(global-set-key [f12] 'recompile)

(setq compilation-scroll-output t)
(setq compilation-window-height 16)
;;

;; Typing of the Dead... erm... Emacs...
(autoload 'typing-of-emacs "typing" "The Typing Of Emacs, a game." t)
(autoload 'sudoku "sudoku" "Sudoku" t)
;;

;; Open Guis without hanging emacs
(defun open-gui (command)
  (interactive "sCommand: ")
  (save-window-excursion
    (let ((cmd (concat command " &"))
           (cmd-buffer (concat "*" command "*")))
      (shell-command cmd cmd-buffer))))
(global-set-key (kbd "C-M-!") 'open-gui)


;; View chm on w3m
;; Requires archmage installed
                                        ;(require 'chm-view)
;;

;; Cor hexadecimal no HTML
;; http://www.emacswiki.org/emacs/HexColour
(defvar hexcolour-keywords
  '(("#[abcdef[:digit:]]\\{6\\}"
      (0 (put-text-property (match-beginning 0)
           (match-end 0)
           'face (list :background
                   (match-string-no-properties 0)))))))

;; Why is this function defined twice?
;; (defun hexcolour-add-to-font-lock ()
;;   (font-lock-add-keywords nil hexcolour-keywords))


(defun hexcolour-luminance (color)
  "Calculate the luminance of a color string (e.g. \"#ffaa00\", \"blue\").
  This is 0.3 red + 0.59 green + 0.11 blue and always between 0 and 255."
  (let* ((values (x-color-values color))
          (r (car values))
          (g (cadr values))
          (b (caddr values)))
    (floor (+ (* .3 r) (* .59 g) (* .11 b)) 256)))

(defun hexcolour-add-to-font-lock ()
  (interactive)
  (font-lock-add-keywords nil
    `((,(concat "#[0-9a-fA-F]\\{3\\}[0-9a-fA-F]\\{3\\}?\\|"
          (regexp-opt (x-defined-colors) 'words))
        (0 (let ((colour (match-string-no-properties 0)))
             (put-text-property
               (match-beginning 0) (match-end 0)
               'face `((:foreground ,(if (> 128.0 (hexcolour-luminance colour))
                                       "white" "black"))
                        (:background ,colour)))))))))

(add-hook 'html-mode-hook 'hexcolour-add-to-font-lock)
;;;;;




(message "Stop 11 %ds" (destructuring-bind (hi lo ms) (current-time)
                         (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))




;; Indent some code within an HTML file
;; http://www.emacswiki.org/emacs/HtmlMode
(defun indent-region-as (other-mode)
  "Indent selected region as some other mode.  Used in order to indent source code contained within HTML."
  (interactive "aMode to use: ")

  (save-excursion
    (let ((old-mode major-mode))
      (narrow-to-region (region-beginning) (region-end))
      (funcall other-mode)
      (indent-region (region-beginning) (region-end) nil)
      (funcall old-mode)))
  (widen))
;;;;

;; Transform accents into html code
;; http://www.emacswiki.org/emacs/html-accent.el
(autoload 'html-accent "html-accent" "Accent HTML" t)
(autoload 'accent-html "html-accent" "HTML codes to accent" t)
;;

(require 'show-wspace)

;; http://www.reddit.com/r/programming/comments/86x46/mx_donuts_pic/
(defun donuts ()
  (interactive)
  (print "Mmmm, donuts."))

;; Browse Kill Ring
;; http://www.emacswiki.org/emacs/BrowseKillRing
(require 'browse-kill-ring)

;; Show free space on device
;; http://www.emacswiki.org/emacs/DfMode
(if (not (Are-We-On-Windows))
  (progn
    (autoload 'df-mode "df-mode" nil t)
    (df-mode 1)))



;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
                                        ;(when
                                        ;  (load
                                        ;    (expand-file-name "~/.emacs.d/elpa/package.el"))
                                        ;  (package-initialize))

;; ;; Configuracao para Haskell
(when (file-exists-p (concat home "elisp/haskell-mode-2.4/haskell-site-file.el"))
  (load (concat home "elisp/haskell-mode-2.4/haskell-site-file"))
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hooj 'turn-on-haskell-indent))

(org-remember-insinuate)

;; http://metajack.im/2008/12/30/gtd-capture-with-emacs-orgmode/
(defadvice remember-finalize (after delete-remember-frame activate)
  "Advise remember-finalize to close the frame if it is the remember frame"
  (if (equal "*Remember*" (frame-parameter nil 'name))
    (delete-frame)))

(defadvice remember-destroy (after delete-remember-frame activate)
  "Advise remember-destroy to close the frame if it is the remember frame"
  (if (equal "*Remember*" (frame-parameter nil 'name))
    (delete-frame)))

;; make the frame contain a single window. by default org-remember
;; splits the window.
(add-hook 'remember-mode-hook  'delete-other-windows)

(defun make-remember-frame ()
  "Create a new frame and run org-remember"
  (interactive)
  (make-frame '((name . "*Remember*")
                 (width . 80)
                 (height . 10)
                 (vertical-scroll-bars . nil)
                 (menu-bar-lines . nil)
                 (tool-bar-lines . nil)))
  (select-frame-by-name "*Remember*")
  (org-remember))

(setq org-remember-templates
  '(("Clipboard" ?c "* %T %^{Description}\n %x"
      "~/remember.org" "Interesting")
     ("ToDo" ?t "* TODO %T %^{Summary}"
       "~/remember.org" "Todo")))



(message "Stop 12 %ds" (destructuring-bind (hi lo ms) (current-time)
                         (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))


;; ;; FIXME: Usar hippie-expand
;; (defun rolando-indent-and-dabbrev ()
;;   "Try to use yas/expand to complete a snippet.
;; If it can't find a snippet, run the yas/fallback-baheviour.
;; Otherwise, run dabbrev-expand"
;;   (interactive)
;;   (indent-according-to-mode))
;; ;  (dabbrev-expand nil))
;; ;; Precisa de uns ajustes para poder usar o tab dentro de snippets
;; ;(global-set-key [(tab)] 'rolando-indent-and-dabbrev)

(setq yas/trigger-key (kbd "SPC"))

(defun rolando-change-comma-to-semicolon ()
  "If the character before pressing enter is a ',' change it into a ';' instead
while also doing a newline-and-indent.
If the character is not a ';' simply do a newline-and-indent"
                                        ; Find a way to see if where inside a function call
  (interactive)
  (unless (= (point) 1)
    (if (char-equal ?\, (char-before))
      (progn
        (delete-backward-char 1)
        (insert ";"))))
  (newline-and-indent))

;; TODO: This probably only makes sense in c-mode or c++-mode
                                        ;(define-key global-map (kbd "RET") 'rolando-change-comma-to-semicolon)

;; Experimentar o Hippie-Expand
;; http://stackoverflow.com/questions/151639/yasnippet-and-pabbrev-working-together-in-emacs
(require 'hippie-exp)

(setq hippie-expand-try-functions-list
  '(try-expand-dabbrev
     try-expand-dabbrev-all-buffers
     try-expand-dabbrev-from-kill
     try-complete-file-name-partially
     try-complete-file-name
     try-complete-lisp-symbol-partially
     try-complete-lisp-symbol))

(global-set-key "\M- " 'hippie-expand)



;; Usar minibufferp para saber se estamos no minibuffer
;; http://www.emacsblog.org/2007/03/12/tab-completion-everywhere/
(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
point."
  (interactive "*P")
  (unless (minibufferp (current-buffer))
    (if (and
          (or (bobp) (= ?w (char-syntax (char-before))))
          (or (eobp) (not (= ?w (char-syntax (char-after))))))
                                        ;(dabbrev-expand arg)
      (hippie-expand arg)))
                                        ;(indent-according-to-mode)
                                        ; indent-according-to-mode doesn't work on regions
                                        ;  (indent-region (region-beginning) (region-end)))
  (indent-for-tab-command))

(defun my-tab-fix ()
  (local-set-key [(tab)] 'indent-or-expand))

                                        ;(add-hook 'c-mode-hook          'my-tab-fix)
(add-hook 'sh-mode-hook         'my-tab-fix)
(add-hook 'emacs-lisp-mode-hook 'my-tab-fix)

;; (global-set-key [(tab)] 'indent-or-expand)


                                        ; TODO: Melhorar isto
(defun lisp-switch-keys ()
  (local-set-key (kbd "8") (lambda ()
                             (interactive)
                                        ;(insert-parentheses)
                             (insert "(")))
  (local-set-key (kbd "(") (lambda ()
                             (interactive)
                             (insert "8")))
  (local-set-key (kbd "9") (lambda ()
                             (interactive)
                                        ;(move-past-close-and-reindent)
                             (insert ")")))
  (local-set-key (kbd ")") (lambda ()
                             (interactive)
                             (insert "9"))))

(message "Stop 13 %ds" (destructuring-bind (hi lo ms) (current-time)
                         (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))



(add-hook 'c-mode-hook 'lisp-switch-keys)
(add-hook 'emacs-lisp-mode-hook 'lisp-switch-keys)

;; Dired reuse buffer
;; http://www.emacswiki.org/emacs/DiredReuseDirectoryBuffer
;; we want dired not not make always a new buffer if visiting a directory
;; but using only one dired buffer for all directories.
(defadvice dired-advertised-find-file (around dired-subst-directory activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer))
         (filename (dired-get-filename)))
    ad-do-it
    (when (and (file-directory-p filename)
            (not (eq (current-buffer) orig)))
      (kill-buffer orig))))

;; Using the methods above will still create a new buffer if you invoke ^
;; (dired-up-directory). To prevent this:
(eval-after-load "dired"
  ;; don't remove `other-window', the caller expects it to be there
  '(defun dired-up-directory (&optional other-window)
     "Run Dired on parent directory of current directory."
     (interactive "P")
     (let* ((dir (dired-current-directory))
             (orig (current-buffer))
             (up (file-name-directory (directory-file-name dir))))
       (or (dired-goto-file (directory-file-name dir))
         ;; Only try dired-goto-subdir if buffer has more than one dir.
         (and (cdr dired-subdir-alist)
           (dired-goto-subdir up))
         (progn
           (kill-buffer orig)
           (dired up)
           (dired-goto-file dir))))))

;; Get the size of all marked files in dired
;; http://www.emacswiki.org/emacs/DiredGetFileSize
(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
        (progn
          (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
          (match-string 1))))))

(define-key dired-mode-map (kbd "?") 'dired-get-size)

;; Place the directories on top of the dired buffer
;; http://www.emacswiki.org/emacs/DiredSortDirectoriesFirst
(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))

;; Dired file size should be human readable
(setq dired-listing-switches "-alh")

(message "Stop 14 %ds" (destructuring-bind (hi lo ms) (current-time)
                         (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))


(defun autocompile nil
  "compile itself if ~/.emacs"
  (interactive)
  (require 'bytecomp)
  (if (string= (buffer-file-name) (expand-file-name (concat default-directory ".emacs")))
    (byte-compile-file (buffer-file-name))))

(add-hook 'after-save-hook 'autocompile)


                                        ;(set-scroll-bar-mode 'right)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode 0)


(message "My .emacs loaded in %ds" (destructuring-bind (hi lo ms) (current-time)
                                     (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))


                                        ;(require 'vimpulse)
;; Activate occur easily inside isearch
;; From http://github.com/technomancy/emacs-starter-kit/blob/master/starter-kit-bindings.el
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

(defun rolando-find-prev-good-buffer ()
  "Goto to the previous buffer, ignoring buffers that start and end with a *"
  (previous-buffer)
  (if (and (string-match "\\\*.*\\\*" (buffer-name))
        (not (string-match "\\\*scratch\\\*" (buffer-name))))
    (rolando-find-prev-good-buffer)))

(defun rolando-find-next-good-buffer ()
  "Goto to the next buffer, ignoring buffers that start and end with a *"
  (next-buffer)
  (if (and (string-match "\\\*.*\\\*" (buffer-name))
        (not (string-match "\\\*scratch\\\*" (buffer-name))))
    (rolando-find-next-good-buffer)))

;; Viper keys to quickly change buffers
;; (define-key viper-vi-basic-map (kbd "<right>")
;;   (lambda ()
;;     (interactive)
;;     (rolando-find-next-good-buffer)))

;; (define-key viper-vi-basic-map (kbd "<left>")
;;   (lambda ()
;;     (interactive)
;;       (rolando-find-prev-good-buffer)))

;; From http://github.com/technomancy/emacs-starter-kit/blob/master/starter-kit-misc.el
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))

;; Default to unified diffs
(setq diff-switches "-u")

;; This should be a defadvice
;; Change the color of the mode line when entering insert-mode and vi-mode
;; (defun viper-change-state (new-state)
;;   ;; Keep viper-post/pre-command-hooks fresh.
;;   ;; We remove then add viper-post/pre-command-sentinel since it is very
;;   ;; desirable that viper-pre-command-sentinel is the last hook and
;;   ;; viper-post-command-sentinel is the first hook.

;;   (when (eq new-state 'insert-state)
;;     (set-face-background 'modeline "steelblue4")
;;     (set-face-foreground 'modeline "black"))
;;   (when (eq new-state 'vi-state)
;;     (set-face-background 'modeline "gray50")
;;     (set-face-foreground 'modeline "black"))


;;   (when (featurep 'xemacs)
;;     (make-local-hook 'viper-after-change-functions)
;;     (make-local-hook 'viper-before-change-functions)
;;     (make-local-hook 'viper-post-command-hooks)
;;     (make-local-hook 'viper-pre-command-hooks))

;;   (remove-hook 'post-command-hook 'viper-post-command-sentinel)
;;   (add-hook 'post-command-hook 'viper-post-command-sentinel)
;;   (remove-hook 'pre-command-hook 'viper-pre-command-sentinel)
;;   (add-hook 'pre-command-hook 'viper-pre-command-sentinel t)
;;   ;; These hooks will be added back if switching to insert/replace mode
;;   (remove-hook 'viper-post-command-hooks
;; 	       'viper-insert-state-post-command-sentinel 'local)
;;   (remove-hook 'viper-pre-command-hooks
;; 	       'viper-insert-state-pre-command-sentinel 'local)
;;   (setq viper-intermediate-command nil)
;;   (cond ((eq new-state 'vi-state)
;; 	 (cond ((member viper-current-state '(insert-state replace-state))

;; 		;; move viper-last-posn-while-in-insert-state
;; 		;; This is a normal hook that is executed in insert/replace
;; 		;; states after each command.  In Vi/Emacs state, it does
;; 		;; nothing.  We need to execute it here to make sure that
;; 		;; the last posn was recorded when we hit ESC.
;; 		;; It may be left unrecorded if the last thing done in
;; 		;; insert/repl state was dabbrev-expansion or abbrev
;; 		;; expansion caused by hitting ESC
;; 		(viper-insert-state-post-command-sentinel)

;; 		(condition-case conds
;; 		    (progn
;; 		      (viper-save-last-insertion
;; 		       viper-insert-point
;; 		       viper-last-posn-while-in-insert-state)
;; 		      (if viper-began-as-replace
;; 			  (setq viper-began-as-replace nil)
;; 			;; repeat insert commands if numerical arg > 1
;; 			(save-excursion
;; 			  (viper-repeat-insert-command))))
;; 		  (error
;; 		   (viper-message-conditions conds)))

;; 		(if (> (length viper-last-insertion) 0)
;; 		    (viper-push-onto-ring viper-last-insertion
;; 					  'viper-insertion-ring))

;; 		(if viper-ESC-moves-cursor-back
;; 		    (or (bolp) (viper-beginning-of-field) (backward-char 1))))
;; 	       ))

;; 	;; insert or replace
;; 	((memq new-state '(insert-state replace-state))
;; 	 (if (memq viper-current-state '(emacs-state vi-state))
;; 	     (viper-move-marker-locally 'viper-insert-point (point)))
;; 	 (viper-move-marker-locally
;; 	  'viper-last-posn-while-in-insert-state (point))
;; 	 (add-hook 'viper-post-command-hooks
;; 		   'viper-insert-state-post-command-sentinel t 'local)
;; 	 (add-hook 'viper-pre-command-hooks
;; 		   'viper-insert-state-pre-command-sentinel t 'local))
;; 	) ; outermost cond

;;   ;; Nothing needs to be done to switch to emacs mode! Just set some
;;   ;; variables, which is already done in viper-change-state-to-emacs!

;;   ;; ISO accents
;;   ;; always turn off iso-accents-mode in vi-state, or else we won't be able to
;;   ;; use the keys `,',^ , as they will do accents instead of Vi actions.
;;   (cond ((eq new-state 'vi-state) (viper-set-iso-accents-mode nil));accents off
;; 	(viper-automatic-iso-accents (viper-set-iso-accents-mode t));accents on
;; 	(t (viper-set-iso-accents-mode nil)))
;;   ;; Always turn off quail mode in vi state
;;   (cond ((eq new-state 'vi-state) (viper-set-input-method nil)) ;intl input off
;; 	(viper-special-input-method (viper-set-input-method t)) ;intl input on
;; 	(t (viper-set-input-method nil)))

;;   (setq viper-current-state new-state)

;;   (viper-update-syntax-classes)
;;   (viper-normalize-minor-mode-map-alist)
;;   (viper-adjust-keys-for new-state)
;;   (viper-set-mode-vars-for new-state)
;;   (viper-refresh-mode-line)
;; )


;; (set-face-background 'modeline-inactive "black")

;; (custom-set-faces
;;   '(mode-line ((t (:box (:line-width 1 :color "orange"))))))

;; Register jumping: ‘C-x r j e’ to open DotEmacs,
;; ‘C-x r j i’ to open an ‘ideas’ file:
;; http://www.emacswiki.org/emacs-en/EmacsNiftyTricks
(set-register ?e '(file . "~/.emacs"))
(set-register ?i '(file . "~/org/ideas.org"))
(set-register ?h '(file . "~/Área de Trabalho/humor.txt"))

(defun rolando-help-jump-to-source-file ()
  "Open up the file where the function/variable definition is defined."
  (interactive)
  (pop-to-buffer "*Help*")
  (goto-char (point-min))
  (when (or (re-search-forward "`.*\.el'" nil t)
          ;; If we can't find a .el file, search for "C source code"
          (re-search-forward "`C source"))
    (backward-char 2)
    (push-button))
  ;; Delete the window showing buffer *Help*
  (delete-windows-on "*Help*"))

(global-set-key (kbd "C-c j") 'rolando-help-jump-to-source-file)

;; Use this yow.lines file
(setq yow-file "~/.emacs.d/misc/yow.lines")

(global-set-key (kbd "C-c i") 'string-rectangle)

;; Not so sure about this one
                                        ;(global-set-key (kbd "C-c k") 'kill-rectangle)

;; Didn't I had a reason to remove this a while ago?
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Lets try this
;; http://www.emacswiki.org/emacs-en/EmacsNiftyTricks
; Not so useful
;(global-set-key (kbd "RET") 'newline-and-indent)

;; XXX: Workaround a bug where ispell doesn't work with words that contain the
;; char ç or Ç
(defun ispell-get-casechars ()
  "[a-zA-ZÁÂÉÓàáâéêíóãúçÇ]")

(defun ispell-get-not-casechars ()
  "[^a-zA-ZÁÂÉÓàáâéêíóãúçÇ]")

;; Define movement keys for man mode
(require 'man)
(define-key Man-mode-map "j" 'next-line)
(define-key Man-mode-map "k" 'previous-line)
(define-key Man-mode-map "K" 'Man-kill)

;; Only show files matching the regexp on a Dired buffer
(defun dired-show-files-match-regexp (regexp)
  "Show on the dired buffer the files that match a certain regexp"
  (interactive "s files (regexp): ")
  (dired-mark-files-regexp regexp)
  (dired-toggle-marks)
  (dired-do-kill-lines))

;; r isn't the best keybinding, but it will work
(define-key dired-mode-map (kbd "r") 'dired-show-files-match-regexp)

;; Turn off yasnippet mode on the debugger
(add-hook 'gdb-mode-hook 'yas/minor-mode-off)

;; (set-face-background 'modeline-inactive "black")

;; (custom-set-faces
;;   '(mode-line ((t (:box (:line-width 1 :color "orange"))))))

(add-hook 'c-mode-common-hook
  (lambda ()
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

(add-hook 'c-mode-common-hook
  (lambda ()
    (setq indent-tabs-mode t)))

;; Yes, you can do this same trick with the cool "It's All Text"
;; firefox add-on :-)
(add-to-list 'auto-mode-alist '("/mutt-\\|itsalltext.*mail\\.google" .  mail-mode))
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(add-hook 'mail-mode-hook
  (lambda ()
    (define-key mail-mode-map [(control c) (control c)]
      (lambda ()
        (interactive)
        (save-buffer)
        (server-edit)))))

;; My general lisp configurations
(add-hook 'lisp-mode-hook 'yas/minor-mode-off)
 ; Doesn't seem to function if it's inside `lisp-hook-function'
(add-hook 'lisp-mode-hook 'lisp-switch-keys)

;; If slime is on, then <f7> evals the entire buffers
(add-hook 'lisp-mode-hook (lambda ()
                            (local-set-key (kbd "<f7>")
                                   'slime-eval-buffer)))


;; Slime stuff
(add-to-list 'load-path (concat home "elisp/slime/"))
(autoload 'slime "slime" "" t)
(eval-after-load "slime"
  '(progn
     (setq inferior-lisp-program "sbcl")
     (require 'slime)
     (slime-setup '(slime-fancy))
     ))

;; Save history of minibuffer between emacs sessions
(savehist-mode 1)
;; Also save kill-ring between emacs sessions
;; From news://gnu.emacs.help
(setq savehist-additional-variables '(kill-ring
                                       ;compile-command
                                       ))

;; "a" key on a dired buffer opens the folder without opening a new buffer
;; unlike RET.
(put 'dired-find-alternate-file 'disabled nil)

;; Smex - Search M-x
(require 'smex)
(smex-initialize)

(defun total-number-lines ()
  "Total number of lines on a buffer.

To add this to the mode-line, place (:EVAL (format '%s' (total-number-lines)))
somewhere on the variable mode-line-format."
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (line-number-at-pos)))

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Some custom commands for eshell
(defun eshell/ff (file)
  (find-file file))

(defun change-to-eshell-or-to-prev-buffer ()
  (interactive)
  (if (string= (buffer-name) "*eshell*") ; Doesn't work with multiple eshells
    (switch-to-buffer (other-buffer))
    (eshell)))

(global-set-key (kbd "<f9>") 'change-to-eshell-or-to-prev-buffer)
;; This is sweet!  right-click, get a list of functions in the source
;; file you are editing
;; (http://emacs.wordpress.com/2007/01/24/imenu-with-a-workaround/#comment-51)
(global-set-key [mouse-3] 'imenu)
(defun download-youtube-video (url)
  (eshell-eval-command
    (eshell-command
      (concat "~/Área\\ de\\ Trabalho/youtube-dl.py -t " url))))
