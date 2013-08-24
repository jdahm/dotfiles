;; set sane exec path before anything else.
(push "/usr/local/bin" exec-path)

(add-to-list 'load-path "~/.emacs.d")

;; create the emacs.d hierarchy
(make-directory "~/.local/share/emacs" t)
(make-directory "~/.local/share/emacs/backups" t)
(make-directory "~/.local/share/emacs/auto-save-files" t)

;; Emacs internal-customization
(setq custom-file "~/.local/share/emacs/custom.el")
(load custom-file 'noerror)

;; Backup placement
;; Save all tempfiles in $TMPDIR/emacs$UID/                                                        
(defconst emacs-tmp-dir (format "%s/%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;; Local customization
(add-to-list 'load-path "~/.config/emacs")
(load "~/.config/emacs/init.el" 'noerror)

;; UTF-8
(setq buffer-file-coding-system 'utf-8-unix)
(setq default-file-name-coding-system 'utf-8-unix)
(setq default-keyboard-coding-system 'utf-8-unix)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(setq default-sendmail-coding-system 'utf-8-unix)
(setq default-terminal-coding-system 'utf-8-unix)

;; Helpful functions
(load "iwb.el")
(global-set-key (kbd "C-c i b") 'duplicate-line-or-region)
(load "duplicate-line-or-region.el")
(global-set-key (kbd "C-c d") 'duplicate-line-or-region)
(load "find-alternate-file-with-sudo.el")
(global-set-key (kbd "C-x C-r") 'find-alternative-file-with-sudo)

;; Theme
(load-theme 'tango-dark t)

