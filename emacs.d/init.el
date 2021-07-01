(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)

(straight-use-package 'zenburn-theme)
(load-theme 'zenburn t)

(straight-use-package 'selectrum)
(selectrum-mode +1)

(tool-bar-mode -1)

(set-face-attribute 'default nil :height 140)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

