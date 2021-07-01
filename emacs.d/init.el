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

(add-hook 'kill-emacs-query-functions
          'custom-prompt-customize-unsaved-options)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

