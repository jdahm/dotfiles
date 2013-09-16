;; set sane exec path before anything else.
(push "/usr/local/bin" exec-path)

(add-to-list 'load-path "~/.emacs.d")

;; create the local hierarchy
(make-directory "~/.local/share/emacs" t)
(make-directory "~/.local/share/emacs/saves" t)

;; Emacs internal-customization
(setq custom-file "~/.local/share/emacs/custom.el")
(load custom-file 'noerror)

;; Local customization
(add-to-list 'load-path "~/.config/emacs")
(load "~/.config/emacs/init.el" 'noerror)

(setq auto-save-list-file-prefix "~/.local/share/emacs/saves/")

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

;; Theme
(load-theme 'tango-dark t)

;; C-coding style (from kernel coding style guide)
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "~/src/linux-trees")
                                       filename))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))))
