;;; ~/.emacs.d/init.el: Emacs configuration
;;
;; Johann Dahm

(defvar config-d "~/.config/emacs/")
(defvar lisp-d (expand-file-name "lisp/" user-emacs-directory))

;; Set package archives and initialize
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; Require `use-package' and `bind-key'
(require 'use-package)
(require 'bind-key)

;; Load core functions
(require 'jd-defuns)

;; Character encodings default to utf-8
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Create sub-directories
(jd/mkdir-p (jd/emacs.d "tmp"))
(jd/mkdir-p (jd/emacs.d "etc"))

;; Keep backups and auto-saves in a separate directory
(jd/mkdir-p (jd/cache-for "backups"))
(jd/mkdir-p (jd/cache-for "auto-save-list"))
(setq backup-directory-alist
      `((".*" . ,(jd/cache-for "backups/"))))
(setq auto-save-file-name-transforms
      `((".*" ,(jd/cache-for "auto-save-list/") t)))

;; Set location for savehist file
(setq savehist-file (jd/cache-for "history"))

;; Change bookmarks file location
(setq bookmark-file (jd/emacs.d "etc/bookmarks"))

;; Change save-places file location
(setq save-place-file (jd/cache-for "places"))

;; Change eshell directory
(setq eshell-directory-name (jd/cache-for "eshell"))

;; Change recentf file location
(setq recentf-save-file (jd/cache-for "recentf"))

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
(bind-key "C-i" 'info-display-manual help-map)
(bind-key "C-s" 'customize-apropos help-map)

;; Replace and add a few critical functions
(use-package jd-buffer
  :bind (("C-x a b" . create-scratch-buffer)
         ("C-x k" . kill-current-buffer)))

(use-package jd-editing
  :bind (("C-c n" . tidy-region-or-buffer)
         ("C-x a r" . align-regexp)
         ("M-<up>" . move-line-up)
         ("M-<down>" . move-line-down)
         ("C-c +" . my-increment-number-at-point)
         ("C-c i" . my-decrement-number-at-point)))

(use-package dired
  :init
  (require 'jd-dired)
  (autoload 'dired-jump "dired-x"
    "Jump to Dired buffer corresponding to current buffer." t)
  (autoload 'dired-jump-other-window "dired-x"
    "Like \\[dired-jump] (dired-jump) but in other window." t)
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  :bind (("C-x C-j" . dired-jump)
         ("C-x 4 C-j" . dired-jump-other-window)
         :map dired-mode-map
         ("b" . dired-open-file)
         ("c" . dired-open-fm))
  :config
  (setq-default insert-directory-program "gls")
  (setq-default dired-listing-switches "-lhva")
  (setq-default dired-clean-up-buffers-too t)
  (setq-default dired-recursive-copies 'always)
  (setq-default dired-recursive-deletes 'top))

;; Use C-h to delete char backward. This:
;; * avoids having to hit DEL extending pinky
;; * is consistent with terminals
;; (define-key key-translation-map [?\C-h] [?\C-?])
;; (bind-key "C-h" 'isearch-delete-char isearch-mode-map)
;; (bind-key "C-?" 'isearch-delete-char help-mode-map)
;; (bind-key "C-?" 'help-command)
;; (bind-key "M-?" 'mark-paragraph)
;; (bind-key "C-h" 'delete-backward-char)
;; (bind-key "M-h" 'backward-kill-word)

(use-package shell
  :init (add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)
  :bind (("C-c s" . shell)))

;; Ivy and Avy
(use-package ivy
  :ensure t
  :diminish (ivy-mode counsel-mode)
  :bind (("C-c C-r" . ivy-resume)
         ("C-c i" . counsel-imenu)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c L" . counsel-git-log)
         ("C-c u" . counsel-unicode-char)
         ("C-x l" . counsel-locate)
         ("C-c l" . counsel-ag)
         ;; ("C-x j" . counsel-bookmark)
         ;; ([remap bookmark-jump] . counsel-bookmark)
         ;; ("C-r" . swiper)
         ;; ("C-s" . counsel-grep-or-swiper)
         ;; :map isearch-mode-map ("M-o" . swiper-from-isearch)
         :map lisp-mode-shared-map ("M-i" . counsel-el))
  :init
  (ivy-mode 1)
  (counsel-mode 1))

(use-package avy
  :ensure t
  :bind (("C-;" . avy-goto-char)
	 ("C-'" . avy-goto-char-2)
	 ("M-g a" . avy-goto-line)
	 ("M-g w" . avy-goto-word-1)
         ("C-M-s" . avy-goto-char-timer)))

(use-package tiny
  :ensure t
  :bind (("C-M-;" . tiny-expand)))

;; Load from here.
(add-to-list 'load-path lisp-d)

;; Additional Modes
(use-package iedit
  :bind (("C-c ;" . iedit-mode)))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.css?\\'" . web-mode)))

;; Version-control
(use-package git-timemachine)
(use-package vc
  :init
  (require 'jd-git)
  (require 'vc-dir)
  :bind
  (:map vc-prefix-map
        ("r" . vc-revert-buffer)
        ("a" . my-vc-git-add)
        ("u" . my-vc-git-reset)
        :map vc-dir-mode-map
        ("r" . vc-revert-buffer)
        ("a" . my-vc-git-add)
        ("u" . my-vc-git-reset)
        ("g" . my-vc-refresh)))

(use-package ibuffer-vc
  :init
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))
  :bind (("C-x C-b" . ibuffer)))

(use-package hydra :ensure t)
(bind-key "M-p" 'bookmark-jump)

(use-package ace-link :config (ace-link-setup-default))

(bind-key "C-c m" 'compile)

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
  ("u" hydra-universal-argument "universal")
  ("m" headlong-bookmark-jump))
(global-set-key (kbd "C-M-o") 'hydra-window/body)

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

(use-package octave
  :mode (("\\.m\\'" . octave-mode)))

(use-package cc-mode
  :init
  (require 'jd-cc)
  (add-hook 'c++-mode-hook (lambda ()
			     (c-set-style "stroustrup")
			     (c-set-offset 'namespace-open 0)
			     (c-set-offset 'namespace-close 0)
			     (c-set-offset 'innamespace 0)))
  (add-hook 'c-mode-common-hook
	    (lambda ()
	      (font-lock-add-keywords nil
				      '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t))))))

(use-package company
  :ensure t
  :diminish company-mode
  :init (add-hook 'after-init-hook #'global-company-mode))

(use-package ggtags
  :ensure t
  :diminish ggtags-mode
  :init (add-hook 'after-init-hook (ggtags-mode t)))

(setq custom-file (expand-file-name "custom.el" config-d))
(if (file-readable-p custom-file) (load-file custom-file))
