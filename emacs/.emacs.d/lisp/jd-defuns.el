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

(provide 'jd-defuns)
