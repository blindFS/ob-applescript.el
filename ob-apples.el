;;; ob-apples.el --- org-babel functions for template evaluation

;; Copyright (C) Stig Brautaset

;; Author: Stig Brautaset
;; Keywords: literate programming, reproducible research, mac
;; Homepage: http://github.com/stig/ob-applescript.el
;; Version: 0.01

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Requirements:

;; Use this section to list the requirements of this language.  Most
;; languages will require that at least the language be installed on
;; the user's system, and the Emacs major mode relevant to the
;; language be installed as well.

 ;;; Code:
(require 'ob)
(require 'ob-core)
(require 'ob-ref)
(require 'ob-eval)

;; Define tangle extension.
(add-to-list 'org-babel-tangle-lang-exts '("applescript" . "scpt"))
(add-to-list 'org-babel-tangle-lang-exts '("apples" . "scpt"))

(defvar org-babel-default-header-args:apples
  '((:results . "silent") (:export . "none")))

(defun org-babel-expand-body:applescript (body params)
  "Expand BODY according to PARAMS, return the expanded body."
  (let ((vars (org-babel--get-vars params)))
    (mapc
     (lambda (pair)
       (let ((name (symbol-name (car pair)))
	           (value (cdr pair)))
	       (setq body
	             (replace-regexp-in-string
                (regexp-quote name)
		            (if (stringp value) value (format "%S" value))
		            body
		            t
		            t))))
     vars)
    body))

(defun org-babel-execute:applescript (body params)
  "Execute a block of AppleScript code with org-babel.
 This function is called by `org-babel-execute-src-block'"
  (message "executing AppleScript source code block")
  (let ((full-body (org-babel-expand-body:applescript body params)))
    (org-babel-eval "osascript" full-body)
    nil))

(defun org-babel-execute:apples (body params)
  "Execute a block of AppleScript with org-babel."
  (org-babel-execute:applescript body params))

(provide 'ob-apples)
;;; ob-apples.el ends here
