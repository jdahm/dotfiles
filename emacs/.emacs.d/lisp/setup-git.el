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
      default)))

;; (defun git-root ()
;;   "Return GIT_ROOT if this file is a part of a git repo,
;; else return nil"
;;   (let ((curdir default-directory)
;;         (max 10)
;;         (found nil))
;;     (while (and (not found) (> max 0))
;;       (progn
;;         (if (file-directory-p (concat curdir ".git"))
;;             (progn
;;               (setq found t))
;;           (progn
;;             (setq curdir (concat curdir "../"))
;;             (setq max (- max 1))))))
;;     (if found (expand-file-name curdir))))

;; Derived from `vc-git-grep'.
(defun git-grep (regexp &optional dir)
  "Run git grep, searching for REGEXP in directory DIR.
DIR defaults to the root directory of the git project.
With \\[universal-argument] prefix, you can edit the constructed shell command line
before it is executed.
With two \\[universal-argument] prefixes, directly edit and run `grep-command'.
Collect output in a buffer.  While git grep runs asynchronously, you
can use \\[next-error] (M-x next-error), or \\<grep-mode-map>\\[compile-goto-error] \
in the grep output buffer,
to go to the lines where grep found matches.
This command shares argument histories with \\[rgrep] and \\[grep]."
  (interactive
   (progn
     (grep-compute-defaults)
     (cond
      ((equal current-prefix-arg '(16))
       (list (read-from-minibuffer "Run: " "git grep"
  			   nil nil 'grep-history)
	     nil))
      (t (let* ((regexp (grep-read-regexp))
		(dir (read-directory-name "In directory: "
					  (locate-dominating-file default-directory ".git") default-directory t)))
	   (list regexp dir))))))
  (require 'grep)
  (when (and (stringp regexp) (> (length regexp) 0))
    (let ((command regexp))
      (if (string= command "git grep")
          (setq command nil))
      (setq dir (file-name-as-directory (expand-file-name dir)))
      (setq command
            (grep-expand-template "git grep -n -e <R>"
                                  regexp))
      (when command
        (if (equal current-prefix-arg '(4))
            (setq command
                  (read-from-minibuffer "Confirm: "
                                        command nil nil 'grep-history))
          (add-to-history 'grep-history command)))
      (when command
	(let ((default-directory dir)
	      (compilation-environment (cons "PAGER=" compilation-environment)))
	  ;; Setting process-setup-function makes exit-message-function work
	  ;; even when async processes aren't supported.
	  (compilation-start command 'grep-mode))
	(if (eq next-error-last-buffer (current-buffer))
	    (setq default-directory dir))))))

;; (defun git-grep ()
;;   "git-grep the entire current repo"
;;   (iteractive)
;;   (let ((search (git-grep-prompt))
;;          (dir ))
;;     (vc-git-grep search "*" dir)))
;;   ;; (grep-find (concat "git --no-pager grep -P -n "
;;   ;;                    (shell-quote-argument search)
;;   ;;                    " `git rev-parse --show-toplevel`")))

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
        (setq args (concat "make -k"  target))
        (setq args (concat "make -k -C \"" directory "\" " target)))
    (compile args)))

(global-set-key (kbd "C-c g")   'git-grep)
(global-set-key (kbd "C-c m")   'git-compile)
(global-set-key (kbd "C-c C-m") 'recompile)

(provide 'setup-git)
