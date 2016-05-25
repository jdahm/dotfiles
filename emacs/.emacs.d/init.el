;; Emacs config
;; Author: Johann Dahm <jdahm@fastmail.com>

(defvar config-d "~/.config/emacs/")
(defvar lisp-d (expand-file-name "lisp/" user-emacs-directory))

;; Set package archives and initialize.
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load core functions.
(load-file (expand-file-name "core-defuns.el" lisp-d))

;; Create sub-directories.
(jd/mkdir-p (jd/emacs.d "tmp"))
(jd/mkdir-p (jd/emacs.d "etc"))
(jd/mkdir-p (jd/cache-for "backups"))

;; Character encodings default to utf-8.
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Keep backups in a separate directory.
(defun make-backup-file-name (file)
  (concat (jd/cache-for "backups/") (file-name-nondirectory file) "~"))

;; Keep autosave files in /tmp.
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Change auto-save-list directory.
(setq auto-save-list-file-prefix (jd/cache-for "auto-save-list/.saves-"))

;; Change eshell directory.
(setq eshell-directory-name (jd/cache-for "eshell"))

;; Disable annoying lock files.
(setq create-lockfiles nil)

;; Change recentf file location.
(setq recentf-save-file (jd/cache-for "recentf"))

;; Set max number of recentf menu items.
(setq recentf-max-menu-items 25)

;; Set location for ede cache of visited projects.
(setq ede-project-placeholder-cache-file (jd/cache-for "ede-projects.el"))

;; Set location for savehist file.
(setq savehist-file (jd/cache-for "history"))

;; Change bookmarks file location.
(setq bookmark-file (jd/emacs.d "etc/bookmarks"))

;; Change save-places file location.
(setq save-place-file (jd/cache-for "places"))

;; Show column numbers in mode line.
(setq column-number-mode t)

;; Don't use dialog boxes.
(setq use-dialog-box nil)

;; Move files to trash when deleting.
(setq delete-by-moving-to-trash t)

;; Disable message in startup buffer.
(setq inhibit-startup-message t)

;; Enable y/n answers.
(defalias 'yes-or-no-p 'y-or-n-p)

;; ring-bell-function = `invert-face' on modeline.
(setq visible-bell nil)
(setq ring-bell-function (lambda ()
			   (invert-face 'mode-line)
			   (run-with-timer 0.1 nil 'invert-face 'mode-line)))

;; Add useful functions to help-map.
(bind-key "C-i" 'info-display-manual help-map)
(bind-key "C-s" 'customize-apropos help-map)

;; Replace and add a few critical functions.
(load-file (expand-file-name "buffer.el" lisp-d))
(bind-key "C-x a b" 'create-scratch-buffer)
(bind-key "C-x k" 'kill-current-buffer)

(load-file (expand-file-name "editing.el" lisp-d))
(bind-key "C-c n" 'tidy-region-or-buffer)
(bind-key "C-x a r" 'align-regexp)

(bind-key "M-<up>" 'move-line-up)
(bind-key "M-<down>" 'move-line-down)

(bind-key "C-c +" 'my-increment-number-at-point)
(bind-key "C-c -" 'my-decrement-number-at-point)

(use-package dired
  :init
  (load-file (expand-file-name "dired.el" lisp-d))
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  :bind (:map dired-mode-map
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

(use-package compile
  :init (setq compilation-scroll-output 'first-error))

(use-package swiper
  :ensure t
  :init
  (use-package counsel
    :ensure t
    :bind (("M-x" . counsel-M-x)
           ("C-x C-f" . counsel-find-file)
           ("C-c g" . counsel-git)
           ("C-c j" . counsel-git-grep)
           ("C-x l" . counsel-locate)
           ("C-c L" . counsel-git-log)
           ("C-c i" . counsel-imenu)
           ("C-c t" . counsel-load-theme)
           ("M-y" . counsel-yank-pop)
           :map help-map
           ("C-f" . counsel-describe-function)
           ("C-v" . counsel-describe-variable)
           ("C-k" . counsel-descbinds)
           ("u" . counsel-unicode-char)
           ("l" . counsel-load-library)
           :map lisp-mode-shared-map
           ("M-i" . counsel-el)
           :map lisp-mode-map
           ("M-i" . counsel-cl)))
  (ivy-mode 1)
  :bind (("C-s" . counsel-grep-or-swiper)
         ("C-r" . counsel-grep-or-swiper)))
  ;; :bind (:map isearch-mode-map ("M-o" . swiper-from-isearch)))

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

(use-package iedit
  :ensure t
  :bind (("C-c ;" . iedit-mode)))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode))
  :bind (("C-m" . newline-and-indent)))

(use-package web-mode
  :ensure t
  :init
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.css?\\'" . web-mode)))

(use-package magit
  :ensure t
  :init
  (add-hook 'magit-mode-hook #'magit-load-config-extensions)
  :config
  (use-package git-timemachine :ensure t)
  :bind (("C-x g" . magit-status)))
(use-package projectile
  :ensure t
  :bind (("C-c m" . projectile-compile-project)))

(use-package ibuffer-vc
  :ensure t
  :init
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))
  :bind (("C-x C-b" . ibuffer)))

(use-package hydra :ensure t)
(bind-key "M-p" 'bookmark-jump)
(use-package ace-window :ensure t)
(use-package ace-link :ensure t
  :init (ace-link-setup-default))
(use-package headlong
  :ensure t
  :bind (("M-o" . headlong-bookmark-jump)))

(use-package key-chord
  :ensure t
  :init (key-chord-mode 1))

;; Better manage window layouts with winner-mode.
(winner-mode 1)

(defhydra hydra-window (global-map "C-M-o")
  "window"
  ("h" windmove-left "left")
  ("j" windmove-down "down")
  ("k" windmove-up "up")
  ("l" windmove-right "right")
  ("a" ace-window "ace")
  ("u" hydra-universal-argument "universal")
  ("s" (lambda () (interactive) (ace-window 4)) "swap")
  ("d" (lambda () (interactive) (ace-window 16)) "delete")
  ("m" headlong-bookmark-jump))

(key-chord-define-global "yy" 'hydra-window/body)

(defhydra hydra-next-error (global-map "C-x")
  "next-error"
  ("`" next-error "next")
  ("j" next-error "next" :bind nil)
  ("k" previous-error "previous" :bind nil)
  ("h" first-error nil :bind nil))

(use-package octave
  :mode (("\\.m\\'" . octave-mode)))

(use-package cc-mode
  :init
  (load-file (expand-file-name "cc.el" lisp-d))
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
  :commands company-mode
  :diminish company-mode
  :init (add-hook 'prog-mode-hook #'company-mode))

(use-package flycheck
  :ensure t
  :commands flycheck-mode
  :diminish flycheck-mode
  :init (add-hook 'prog-mode-hook #'flycheck-mode))

(setq custom-file (expand-file-name "custom.el" config-d))
(if (file-readable-p custom-file) (load-file custom-file))
