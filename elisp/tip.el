; Display Tip of the Day
; Entra em conflito com o Restaurar sessoes
(defconst animate-n-steps 3)
(require 'cl)
(random t)
(defun totd ()
  (interactive)
  (let* ((commands (loop for s being the symbols
                     when (commandp s) collect s))
          (command (nth (random (length commands)) commands)))
    (animate-string (concat ";; Initialization successful, welcome to "
                      (substring (emacs-version) 0 16)
                      "\n"
                      "Your tip for the day is:\n========================\n\n"
                      (describe-function command)
                      (delete-other-windows)
                      "\n\nInvoke with:\n\n"
                      (where-is command t)
                      (delete-other-windows) 
                      )0 0)))

;(add-hook 'after-init-hook 'totd)
;; end tip.el