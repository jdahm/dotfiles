(global-set-key (kbd "C-x g") 'magit-status)
(add-hook 'magit-mode-hook 'magit-load-config-extensions)
(setq magit-last-seen-setup-instructions "1.4.0"
      magit-status-buffer-switch-function 'switch-to-buffer)

(defun git-grep-prompt ()
  "Helper function for `git-grep'"
  (let* ((default (current-word))
         (prompt (if default
                     (concat "Search for: (default " default ") ")
                   "Search for: "))
         (search (read-from-minibuffer prompt nil nil nil nil default)))
    (if (> (length search) 0)
        search
      (or default ""))))

(defun git-grep (search)
  "git-grep the entire current repo"
  (interactive (list (git-grep-prompt)))
  (grep-find (concat "git --no-pager grep -P -n "
                     (shell-quote-argument search)
                     " `git rev-parse --show-toplevel`")))

(defun compile-dir ()
  (let* ((default (locate-dominating-file
                            default-directory ".git"))
         (prompt (if default
                     (concat "Directory: (default " default ") ")
                   "Directory: "))
         (directory (read-from-minibuffer prompt nil nil nil nil default)))
    (if (> (length directory) 0)
        directory
      (or default ""))))

(defun compile-tar ()
  (let* ((default "all")
         (prompt (concat "Target: (default all) "))
         (target (read-from-minibuffer prompt nil nil nil nil default)))
    (if (> (length target) 0)
        target
      (or default ""))))

(defun git-compile ()
  "Run `compile' at a directory with a target."
  (interactive)
  (let ((directory (compile-dir))
        (target (compile-tar)))
    (if (= (length directory) 0)
        (setq args (concat "make -k " target))
        (setq args (concat "make -k -C " directory " " target)))
    (compile args)))

(global-set-key (kbd "C-c g")   'git-grep)
(global-set-key (kbd "C-c m")   'git-compile)
(global-set-key (kbd "C-c C-m") 'recompile)

(provide 'setup-git)
