;; Sources:
;;   * sjrmanning/.emacs.d
;;   * muahah/emacs-profile

(defun require-package (package)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

(defun emacsd-path (path)
  "Return path inside user's `.emacs.d'."
  (expand-file-name path user-emacs-directory))

(defun save-kbd-macro (name)
  "save a macro. Take a name as argument
     and save the last defined macro under
     this name at the end of your .emacs"
  (interactive "Name of the macro :")   ; ask for the name of the macro
  (kmacro-name-last-macro name)         ; use this name for the macro
  (find-file custom-file)               ; open up custom.el file
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer

(provide 'jd-defuns)
