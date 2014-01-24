;; set sane exec path before anything else.
(push "/usr/local/bin" exec-path)

(add-to-list 'load-path "~/.emacs.d/lisp")

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

;; Tabbing
(setq-default indent-tabs-mode t)

;; C
(setq c-default-style "linux"
      c-basic-offset 8
      tab-width 8
      indent-tabs-mode t)

;; MATLAB/Octave
(setq auto-mode-alist
      (append '(("\\.m\\'" . octave-mode)) auto-mode-alist))


;; me
(setq user-full-name "Johann Dahm"
      user-mail-address "johann.dahm@gmail.com")
