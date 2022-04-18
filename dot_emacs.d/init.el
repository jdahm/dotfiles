;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; Sources:
;; * https://github.com/purcell/emacs.d
;; * https://github.com/alhassy/emacs.d

;;; Code:

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

;; Load use-package
(straight-use-package 'use-package)
;; Use straight.el for use-package and always ensure installed
(setq straight-use-package-by-default t)

;; Collect statistics on packages
(setq use-package-compute-statistics t)

;; Constants
(defconst is-a-mac (eq system-type 'darwin))

;; Sane defaults for Emacs
(use-package emacs
  :init
  (setq inhibit-startup-screen t
        sentence-end-double-space nil
        ring-bell-function 'ignore)

  (setq-default initial-scratch-message
                (concat ";; Happy hacking, " user-login-name " - ♥ Emacs!\n\n"))

  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; Default to utf-8 for all the things
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

  ;; Write over selected text on input... like all modern editors do
  (delete-selection-mode t)

  ;; Enable recent files mode.
  (recentf-mode t)

  ;; Disable auto-save files
  (setq auto-save-default nil)

  ;; Use a custom.el file mostly for marking safe file-local-variables
  (setq custom-file (locate-user-emacs-file "custom.el"))

  ;; Follow symlinks
  (setq vc-follow-symlinks t)

  (show-paren-mode t)

  ;; Less noise when compiling elisp
  (setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
  (setq load-prefer-newer t)

  (setq column-number-mode t)

  (setq-default indent-tabs-mode nil
                tab-width 4
                fill-column 80))

(use-package page-break-lines
  :init (global-page-break-lines-mode))

(use-package exec-path-from-shell
  :if is-a-mac
  :hook (emacs-startup . (lambda () (exec-path-from-shell-initialize))))

(defun rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (progn
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))

(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))

(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  :bind (:map help-mode-map
              ("F" . helpful-function)
              ("C" . helpful-command)))

(use-package eldoc
  :hook ((emacs-lisp-mode-hook . eldoc-mode)
         (lisp-interation-mode-hook . eldoc-mode)))

(use-package no-littering
  :demand
  :config
  (setq no-littering-etc-directory
        (expand-file-name "config/" user-emacs-directory))
  (setq no-littering-var-directory
        (expand-file-name "data/" user-emacs-directory))
  (with-eval-after-load 'recentf
    (add-to-list 'recentf-exclude no-littering-var-directory)
    (add-to-list 'recentf-exclude no-littering-etc-directory)))

;; Org
(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :init
  (setq org-superstar-headline-bullets-list '("✖" "✚" "◉" "○" "▶")
        ;; org-superstar-special-todo-items t
        org-ellipsis " ↴ "))

;; Theme
(use-package zenburn-theme
  :init (load-theme 'zenburn t))
;; (use-package nord-theme
;;   :init (load-theme 'nord t))
;; (use-package solarized-theme
;;   :init (load-theme 'solarized-dark t))

;; Modeline
(use-package mood-line
  :hook (after-init . mood-line-mode))

(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Optionally use the `orderless' completion style. See
;; `+orderless-dispatch' in the Consult wiki for an advanced Orderless style
;; dispatcher. Additionally enable `partial-completion' for file path
;; expansion. `partial-completion' is important for wildcard support.
;; Multiple files can be opened at once with `find-file' if you enter a
;; wildcard. You may also give the `initials' completion style a try.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package ctrlf
  :config (ctrlf-mode t))

(use-package marginalia
  :init
  (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  (marginalia-mode)
  :bind
  (:map minibuffer-local-map ("M-A" . marginalia-cycle)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         :map help-mode-map
         ("B" . embark-bindings))

  :config
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package flycheck
  :config (global-flycheck-mode))

(use-package consult
  :init
  (use-package consult-flycheck)
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s F" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi))           ;; needed by consult-line to detect isearch

  ;; Enable automatic preview at point in the *Completions* buffer.
  ;; This is relevant when you use the default completion UI,
  ;; and not necessary for Vertico, Selectrum, etc.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Optionally replace `completing-read-multiple' with an enhanced version.
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-recent-file consult--source-project-recent-file consult--source-bookmark
   :preview-key (kbd "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; Optionally configure a function which returns the project root directory.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (project-roots)
  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project)))))
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-root-function #'projectile-project-root)
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-root-function #'vc-root-dir)
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-root-function (lambda () (locate-dominating-file "." ".git")))
  )

(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Project management
(use-package direnv
  :hook
  (prog-mode-hook . direnv-update-environment)
  :config
  (direnv-mode))

;; Git
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

(use-package git-timemachine
  :hook (git-time-machine-mode . evil-normalize-keymaps)
  :init (setq git-timemachine-show-minibuffer-details t))

(use-package diff-hl
  :hook
  ((magit-pre-refresh . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh))
  :init
  (setq diff-hl-draw-borders nil)
  ;; (setq diff-hl-global-modes '(not org-mode))
  ;; (setq diff-hl-fringe-bmp-function 'diff-hl-fringe-bmp-from-type)
  ;; (setq diff-hl-global-modes (not '(image-mode org-mode)))
  (global-diff-hl-mode))

(use-package company
  :config (global-company-mode t))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package apheleia
  :config (apheleia-global-mode t))

;; Programming
(add-hook 'before-save-hook 'whitespace-cleanup)

(use-package dad-joke
  :defer t
  :config (defun dad-joke () (interactive) (insert (dad-joke-get))))

(use-package hl-todo
  :hook (prog-mode-hook . hl-todo-mode)
  :bind (:map hl-todo-mode-map
              ("C-c p" . hl-todo-previous)
              ("C-c n" . hl-todo-next)
              ("C-c o" . hl-todo-occur)
              ("C-c i" . hl-todo-insert)))

(use-package lsp-mode
  :config
  (setq lsp-clangd-binary-path "clangd")
  (setq lsp-diagnostics-provider :flymake))

(use-package lsp-ui
  :after lsp-mode)

(use-package consult-lsp
  :bind (:map lsp-mode-map ([remap xref-find-apropos] . consult-lsp-symbols)))

;; Python
(use-package blacken
  :commands blacken-mode blacken-buffer)

(use-package python-pytest)

;; Haskell
(use-package haskell-mode)

(use-package lsp-haskell
  :config (setq lsp-haskell-server-path "haskell-language-server-wrapper"))

;; Web
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.phtml?\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[agj]sp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)))

;; Nix
(use-package nix-mode
  :mode (("\\.nix\\'" . nix-mode)
         ("\\.drv\\'" . nix-drv-mode))
  :hook (before-save-hook . nix-format-buffer)
  :custom (nix-indent-function 'nix-indent-line))

;; Text
(use-package toml-mode
  :mode "\\.toml\\'")

(use-package yaml-mode
  :mode ((rx ".yml" eos) . yaml-mode))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package elfeed
  :bind ("C-x w" . elfeed)
  :config
  (setq elfeed-feeds
        '("http://nullprogram.com/feed/"
          "https://planet.emacslife.com/atom.xml"
          "https://jonascarpay.com/rss.xml"
          "https://www.tweag.io/rss.xml"
          "https://www.well-typed.com/blog/rss2.xml"
          "https://changelog.com/gotime/feed")))

(set-face-attribute 'default nil :height 140)

(provide 'init)

;;; init.el ends here
