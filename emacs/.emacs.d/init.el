;;; init.el --- Configuration for Emacs
;;
;;; Author: Johann Dahm <johann@jdahm.me>
;;
;;; Commentary:
;;
;; Configuration for Emacs
;;
;;; Code:

(defconst config-d "~/.config/emacs/")
(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))

;; Set package archives and initialize
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; Load core functions
(require 'jd-defuns)

;; Character encodings default to utf-8
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Create sub-directories
  (dolist (dir (list (cache-for "") (etc-for "")))
    (when (not (file-directory-p dir))
      (make-directory dir t)))

;; Keep backups and auto-saves in a separate directory
;; Put backup files neatly away                                                 
(let ((backup-dir (etc-for "backups"))
      (auto-saves-dir (cache-for "auto-save-list")))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-auto-save-directory auto-saves-dir
        backup-directory-alist `(("." . ,backup-dir))
        tramp-backup-directory-alist `((".*" . ,backup-dir))))

;; Set location for savehist file
(setq savehist-file (cache-for "history"))

;; Change bookmarks file location
(setq bookmark-file (etc-for "bookmarks"))

;; Change save-places file location
(setq save-place-file (cache-for "places"))

;; Change eshell directory
(setq eshell-directory-name (cache-for "eshell"))

;; Change recentf file location
(setq recentf-save-file (cache-for "recentf"))

;; Precaution: Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Enable y/n answers
(defalias 'yes-or-no-p 'y-or-n-p)

;; ring-bell-function = `invert-face' on modeline
(setq visible-bell nil)
(setq ring-bell-function (lambda ()
			   (invert-face 'mode-line)
			   (run-with-timer 0.1 nil 'invert-face 'mode-line)))

;; Add useful functions to help-map
(define-key help-map "\C-i" 'info-display-manual)
(define-key help-map "\C-s" 'customize-apropos)

;; Replace and add a few critical functions
(require 'jd-buffer)
(global-set-key (kbd "C-x a b") 'create-scratch-buffer)
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(require 'jd-editing)
(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "C-c n") 'tidy-region-or-buffer)
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "M-Q") 'unfill-paragraph)
(global-set-key (kbd "C-c +") 'increment-number-at-point)
(global-set-key (kbd "C-c -") 'decrement-number-at-point)

;; Dired
(require 'jd-dired)
(require 'dired)
(autoload 'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload 'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-x 4 C-j") 'dired-jump-other-window)
(define-key dired-mode-map "b" 'dired-open-file)
(define-key dired-mode-map "c" 'dired-open-fm)

(setq-default dired-clean-up-buffers-too t)
(setq-default dired-recursive-copies 'always)
(setq-default dired-recursive-deletes 'top)

;; Shell
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)
(global-set-key (kbd "C-c s") 'shell)

;; Ivy and Avy
(require 'diminish)
(require-package 'ivy)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-c i") 'counsel-imenu)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c L") 'counsel-git-log)
(global-set-key (kbd "C-c u") 'counsel-unicode-char)
(global-set-key (kbd "C-c l") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-s") 'counsel-grep-or-swiper)
(global-set-key (kbd "C-r") 'swiper)
(define-key lisp-mode-shared-map "\M-i" 'counsel-el)
;; ("C-x j" . counsel-bookmark)
;; ([remap bookmark-jump] . counsel-bookmark)
(ivy-mode 1)
(diminish 'ivy-mode)
(counsel-mode 1)
(diminish 'counsel-mode)

(require-package 'avy)
(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g a") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "C-M-s") 'avy-goto-char-timer)

(require-package 'tiny)
(global-set-key (kbd "C-M-;") 'tiny-expand)

(require 'iedit)
(global-set-key (kbd "C-c ;") 'iedit-mode)

(require 'markdown-mode)
(setq markdown-command "multimarkdown")
(dolist (item '(("README\\.md\\'" . gfm-mode)
                ("\\.md\\'" . markdown-mode)
                ("\\.markdown\\'" . markdown-mode)))
  (add-to-list 'auto-mode-alist item))

(require 'web-mode)
(dolist (item '(("\\.html?\\'" . web-mode)
                ("\\.css?\\'" . web-mode)))
  (add-to-list 'auto-mode-alist item))

;; Version-control
(require 'git-timemachine)
(global-set-key (kbd "C-x v t") 'git-timemachine)

(require 'jd-git)
(require 'vc-dir)
(define-key vc-prefix-map "r" 'vc-revert-buffer)
(define-key vc-prefix-map "a" 'vc-git-add)
(define-key vc-prefix-map "u" 'vc-git-reset)
(define-key vc-dir-mode-map "r" 'vc-revert-buffer)
(define-key vc-dir-mode-map "a" 'vc-git-add)
(define-key vc-dir-mode-map "u" 'vc-git-reset)
(define-key vc-dir-mode-map "g" 'vc-refresh)

(require 'ibuffer-vc)
(add-hook 'ibuffer-hook #'ibuffer-vc-set-filter-groups-by-vc-root)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(require-package 'hydra)
(global-set-key (kbd "M-p") 'bookmark-jump)

(require 'ace-link)
(ace-link-setup-default)

;; Global `compile' keybinding
(global-set-key (kbd "C-c m") 'compile)

;; Better manage window layouts with winner-mode.
(winner-mode 1)
(defhydra hydra-window ()
  "window"
  ("h" windmove-left "left")
  ("j" windmove-down "down")
  ("k" windmove-up "up")
  ("l" windmove-right "right")
  ("n" winner-undo "undo")
  ("p" winner-redo "redo")
  ("m" bookmark-jump "bmk"))
(global-set-key (kbd "C-x w") 'hydra-window/body)

(defhydra hydra-next-error (global-map "C-x")
  "
Compilation errors:
_j_: next error        _h_: first error    _q_uit
_k_: previous error    _l_: last error
"
  ("`" next-error     nil)
  ("j" next-error     nil :bind nil)
  ("k" previous-error nil :bind nil)
  ("h" first-error    nil :bind nil)
  ("l" (condition-case err
           (while t
             (next-error))
         (user-error nil))
   nil :bind nil)
  ("q" nil            nil :color blue))

(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(require 'jd-cc)
(add-hook 'c++-mode-hook (lambda ()
                           (c-set-style "stroustrup")
                           (c-set-offset 'namespace-open 0)
                           (c-set-offset 'namespace-close 0)
                           (c-set-offset 'innamespace 0)))
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

;; (require-package 'company)
;; (add-hook 'after-init-hook #'global-company-mode)

(require-package 'ggtags)
(add-hook 'after-init-hook #'ggtags-mode)

(setq custom-file (expand-file-name "custom.el" config-d))
(if (file-readable-p custom-file) (load-file custom-file))

;;; init.el ends here
