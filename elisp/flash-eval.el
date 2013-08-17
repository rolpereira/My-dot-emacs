;;; flash-eval.el --- flashes defun when eval'ing it

;; Copyright (C) 2013  Rolando Pereira

;; Author: Rolando Pereira <rolando_pereira@sapo.pt>
;; Keywords: lisp, languages, faces

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; To install place this file somewhere in your load-path and add the
;; following to your .emacs:
;;
;; (require 'flash-eval)
;; (add-hook 'lisp-interaction-mode-hook (lambda ()
;;                                        (local-set-key (kbd "C-c C-c") #'flash-eval-eval-defun-flash)))
;;
;; (add-hook 'emacs-lisp-mode-hook (lambda ()
;;                                  (local-set-key (kbd "C-c C-c") #'flash-eval-eval-defun-flash)))


;;
;;

;;; Code:

(defun flash-eval--begin-current-defun ()
  "Returns the point representing the beginning of the defun"
  (save-excursion
    (unless (looking-at "(defun")
      (beginning-of-defun))
    (point)))

(defun flash-eval--end-current-defun ()
  "Returns the point representing the end of the defun"
  (save-excursion
    (goto-char (flash-eval--begin-current-defun))
    (forward-sexp)
    (point)))

(defun flash-eval--flash-region (start end)
  "Makes the region between START and END change color for a moment"
  (let ((overlay (make-overlay start end)))
    (overlay-put overlay 'face 'secondary-selection)
    (run-with-timer 0.2 nil 'delete-overlay overlay)))

(defun flash-eval--flash-defun ()
  "Makes the current defun change colors for a moment"
  (let ((start (flash-eval--begin-current-defun))
         (end (flash-eval--end-current-defun)))
    (flash-eval--flash-region start end)))

;;; This is a really bad name...
(defun flash-eval-eval-defun-flash (edebug-it)
  "Evals the current defun and highlights it for a moment

The EDEBUG-IT arguments is passed to `eval-defun'."
  (interactive "P")
  (eval-defun edebug-it)
  (flash-eval--flash-defun))





(provide 'flash-eval)
;;; flash-eval.el ends here
