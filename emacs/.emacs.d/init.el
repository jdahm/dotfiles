;; Set up load path
(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;; Customization file here
(setq custom-file (expand-file-name "~/.config/emacs/init-custom.el"))

;; Turn off the extras
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Frame title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Better defaults
(require 'sane-defaults)

;; Backup
(unless (file-exists-p "~/.emacs.d/backup/")
  (make-directory "~/.emacs.d/backup/" t))

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/backup
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup/"))
      auto-save-file-name-transforms '((".*" "~/.emacs.d/backup/\\1" t)))

(require 'savehist)
(savehist-mode 1)

(require 'saveplace)
(setq-default save-place t)

(require 'recentf)
(setq recentf-max-saved-items 300 ; number of saved items
      recentf-auto-cleanup 600    ; cleanup when idle for 600 seconds
      )
(when (not noninteractive) (recentf-mode 1))

(require 'windmove)
(windmove-default-keybindings)

(require 'dired)
(setq dired-recursive-copies 'always
      dired-recursive-deletes 'always
      delete-by-moving-to-trash t
      dired-dwim-target t)
(setq-default dired-listing-switches "-Al --si --time-style long-iso")
;; hide some details by default
(add-hook 'dired-mode-hook 'dired-hide-details-mode)

(require 'buffer-defuns)
(define-key dired-mode-map (kbd "b") 'dired-open-file)
(define-key dired-mode-map (kbd "c") 'dired-open-fm)

(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-c s") 'eshell)
(global-set-key (kbd "C-c S") 'ansi-term)
(global-set-key (kbd "C-x a k") 'bury-buffer)
(global-set-key (kbd "C-x -") 'toggle-window-split)
(global-set-key (kbd "C-x C--") 'rotate-windows)
(global-set-key (kbd "C-x a b") 'create-scratch-buffer)
(global-set-key (kbd "<f7>") 'prev-buffer)
(global-set-key (kbd "<f8>") 'split-window-show-prev)
(global-set-key (kbd "<f9>") 'toggle-truncate-lines)

(global-unset-key (kbd "C-x C-+"))

(require 'editing-defuns)
(global-set-key (kbd "C-a") 'my-beginning-of-line)
(global-set-key (kbd "C-<down>") 'move-line-down)
(global-set-key (kbd "C-<up>") 'move-line-up)
(global-set-key (kbd "C-c C-a") 'auto-fill-mode)
(global-set-key (kbd "C-c C-w")   'subword-mode)
(global-set-key (kbd "C-c n")   'tidy-region-or-buffer)
(global-set-key (kbd "C-c t")   'cycle-tab-width)
(global-set-key (kbd "C-c i")   'my-url-insert-file-contents)
(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "M-Z")     'zap-up-to-char)

(define-key 'help-command (kbd "C-i") 'info-display-manual)

;; Built-in modes
(require 'octave)
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

;; Writing
(add-hook 'text-mode-hook 'auto-fill-mode)

;; Hidden mode line
(require 'hidden-mode-line-mode)
(global-set-key (kbd "<f6>") 'hidden-mode-line-mode)

;; Packages
(defvar my-packages
  '(cl-lib
    niflheim-theme
    markdown-mode yaml-mode haskell-mode
    git-commit-mode git-rebase-mode gitconfig-mode gitignore-mode git-timemachine magit ibuffer-vc
    org org-present
    ;; flx-ido ido-ubiquitous
    ;; helm helm-ls-git helm-descbinds helm-bibtex helm-git-grep helm-make
    flycheck company counsel swiper smex
    expand-region change-inner multiple-cursors
    jump-char ledger-mode diminish shm elfeed)
  "Packages to ensure are installed.")

(defvar my-themes '(leuven niflheim) "My themes.")
(defvar current-theme nil)

;; Do this for newer Emacs
(when (>= emacs-major-version 24)
  (setq package-archives
	'(("gnu"   . "http://elpa.gnu.org/packages/")
          ("melpa" . "http://melpa.org/packages/")))
  (package-initialize)

  (when (not package-archive-contents) (package-refresh-contents))

  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p)))

  ;; Cycle themes
  (require 'appearance-defuns)
  (global-set-key (kbd "<f5>") 'cycle-my-themes)
  (global-set-key (kbd "C-x <f5>") 'clear-current-theme)

  ;; Match braces and parens
  (require 'elec-pair)
  (electric-pair-mode 1)

  ;; Markdown extensions (apparently not added by requiring feature)
  (add-to-list 'auto-mode-alist '("\\.text$"     . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md$"       . markdown-mode))

  ;; Haskell settings
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  ;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
  ;; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (custom-set-variables '(haskell-process-type 'cabal-repl))
  (eval-after-load 'haskell-mode
    '(progn
       (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
       (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
       (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
       (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
       (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
       (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
       (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
       (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))

  (eval-after-load 'haskell-cabal
    '(progn
       (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
       (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
       (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
       (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

  ;; Ivy instead of ido and helm
  (ivy-mode 1)
  ;; (require 'setup-ido)
  ;; (require 'setup-helm)
  (require 'counsel)
  (defun counsel-recentf ()
    "Find file in the current Git repository."
    (interactive)
    (let* ((cands recentf-list)
           (file (ivy-read "Recent file: " cands)))
      (when file
        (find-file file))))
  (global-set-key (kbd "C-x C-r") 'counsel-recentf)
  (global-set-key (kbd "C-c g") 'counsel-git-grep)
  (global-set-key (kbd "C-c f") 'counsel-git)
  (global-set-key (kbd "C-M-s") 'swiper)

  ;; Smex
  (autoload 'smex "smex"
    "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
your recently and most frequently used commands.")
  (global-set-key (kbd "M-x") 'smex)

  ;; Ibuffer
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))
  (global-set-key (kbd "C-x C-b") 'ibuffer)

  ;; Git
  (require 'setup-git)
  (global-set-key (kbd "C-c m") 'git-compile)
  (global-set-key (kbd "C-c C-m") 'recompile)

  ;; Org
  (require 'setup-org)

  ;; Flycheck
  ;; (global-set-key (kbd "C-c f") 'flycheck-mode)
  ;; (add-hook 'after-init-hook #'global-flycheck-mode)

  ;; ;; Company
  ;; (add-hook 'after-init-hook 'global-company-mode)

  ;; Expand-region
  (global-set-key (kbd "C-=") 'er/expand-region)
  (global-set-key (kbd "C-M-=") 'er/contract-region)

  ;; Change-inner
  (global-set-key (kbd "M-i") 'change-inner)
  (global-set-key (kbd "M-o") 'change-outer)

  ;; Multiple-cursors
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-prev-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

  ;; Jump-char
  (global-set-key (kbd "M-m") 'jump-char-forward)
  (global-set-key (kbd "C-M-m") 'jump-char-backward)

  ;; Ledger-mode
  (add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode)))

;; Load customization file last
(if (file-readable-p custom-file) (load-file custom-file))
