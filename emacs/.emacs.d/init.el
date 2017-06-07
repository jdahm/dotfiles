;;; init.el --- Configuration for Emacs
;;
;;; Author: Johann Dahm <johann.dahm@gmail.com>
;;
;;; Commentary:
;;
;; Configuration for Emacs. Requires Emacs 24 for package.el, Magit.
;;
;;; Code:

(defconst config-d "~/.config/emacs/")
(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))
(setq custom-file (expand-file-name "custom.el" config-d))

;; Set package archives and initialize
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize)

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; Load some defuns
(require 'jd-defuns)

;; Precaution: Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Enable y/n answers
(defalias 'yes-or-no-p 'y-or-n-p)

;; Backups - better to be safe
(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(global-set-key (kbd "C-c t") #'hydra-toggle/body)

(global-set-key (kbd "C-c w") #'whitespace-mode)

;; Keybinding for unfill-paragraph
(global-set-key (kbd "M-Q") #'unfill-paragraph)

;; IBuffer
(require-package 'ibuffer-vc)
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              ;; (ibuffer-do-sort-by-alphabetic))))
              (ibuffer-do-sort-by-vc-status))))
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; Version-control
(require-package 'magit)
;; (global-set-key (kbd "C-c g") #'magit-status)

(require-package 'git-timemachine)
(global-set-key (kbd "C-x v t") #'git-timemachine)


(global-set-key (kbd "C-c a") #'align-regexp)

(global-set-key (kbd "C-c b") #'create-scratch-buffer)

(global-set-key (kbd "C-c s") #'shell)

(global-set-key (kbd "C-c t") #'tidy-region-or-buffer)

(global-set-key (kbd "C-c g") #'magit-status)

;; Ido
(ido-mode 1)
(recentf-mode 1)

;; Dired
(require 'jd-dired)
(require 'dired)

(autoload 'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload 'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(global-set-key (kbd "C-x C-j") #'dired-jump)
(global-set-key (kbd "C-x 4 C-j") #'dired-jump-other-window)

(define-key dired-mode-map (kbd "C-c C-s") 'sudired)
(define-key dired-mode-map "b" 'dired-open-file)
(define-key dired-mode-map "c" 'dired-open-fm)
(define-key dired-mode-map "e" 'ora-ediff-files)
(define-key dired-mode-map "Q" 'dired-do-query-replace-regexp)

(setq-default dired-clean-up-buffers-too t
              dired-recursive-copies 'always
              dired-recursive-deletes 'top)

;; Shell
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

;; Vkill
(autoload 'vkill "vkill" nil t)
(autoload 'list-unix-processes "vkill" nil t)

(require-package 'diminish)

(global-set-key (kbd "M-y") 'yank-pop)

(require-package 'tiny)
(global-set-key (kbd "C-;") 'tiny-expand)
;; (tiny-setup-default)

;; This overwrites `comment-set-column', but that is rarely used and
;; the default binding for comment-line is not terminal-friendly.
(global-set-key (kbd "C-x ;") 'comment-line)

;; Text and Web
(require-package 'markdown-mode)
(setq markdown-command "multimarkdown")
(dolist (item '(("README\\.md\\'" . gfm-mode)
                ("\\.md\\'" . markdown-mode)
                ("\\.markdown\\'" . markdown-mode)))
  (add-to-list 'auto-mode-alist item))

(require-package 'web-mode)
(dolist (item '(("\\.html?\\'" . web-mode)
                ("\\.css?\\'" . web-mode)))
  (add-to-list 'auto-mode-alist item))

;; Windows
(winner-mode 1)
(global-set-key (kbd "C-x p") (lambda () (interactive) (other-window -1)))

;; Macros
(global-set-key (kbd "C-c m") #'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "C-z") #'kmacro-end-or-call-macro)
(global-set-key (kbd "C-c C-z") #'save-kbd-macro)

;; Octave
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

;; C/C++
(require 'jd-cc)
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\|\\MISSING\\)" 1 font-lock-warning-face t)))))

(add-hook 'c-mode-common-hook
          (lambda () (define-key c-mode-base-map (kbd "M-o") 'ff-find-other-file)))

(if (file-readable-p custom-file) (load-file custom-file))

;; Enable disabled commands
(put 'set-goal-column 'disabled nil)

;;; init.el ends here
