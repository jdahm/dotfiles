;; Set up load path
(add-to-list 'load-path (concat user-emacs-directory "lisp/"))
(add-to-list 'load-path "~/.config/emacs")

;; Customization file here
(setq custom-file (expand-file-name "~/.config/emacs/init-custom.el"))

;; Turn off the extras
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Frame title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Better defaults
(require 'sane-defaults)

;; Prefer utf-8
(prefer-coding-system 'utf-8)

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
(setq recentf-auto-cleanup 600
      recentf-max-saved-items 50)
(when (not noninteractive) (recentf-mode 1))

(require 'windmove)
(windmove-default-keybindings)
(winner-mode 1)

(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-create-new-buffer 'always
      ido-use-faces t
      ido-ignore-extensions t
      ido-use-filename-at-point 'guess
      ido-auto-merge-delay-time 3)

(require 're-builder)
(setq reb-re-syntax 'string)

(require 'dired)
(setq dired-recursive-copies 'always
      dired-recursive-deletes 'always
      delete-by-moving-to-trash t
      dired-dwim-target t)
(setq-default dired-listing-switches "-Al --si --time-style long-iso")

(require 'buffer-defuns)
(define-key dired-mode-map (kbd "b") 'dired-open-file)
(define-key dired-mode-map (kbd "c") 'dired-open-fm)

(global-set-key (kbd "C-x k")   'kill-current-buffer)
(global-set-key (kbd "C-c s")   'shell)
(global-set-key (kbd "C-c S")   'eshell)
(global-set-key (kbd "C-x a k") 'bury-buffer)
(global-set-key (kbd "C-x -")   'toggle-window-split)
(global-set-key (kbd "C-x C--") 'rotate-windows)
(global-set-key (kbd "C-x a b") 'create-scratch-buffer)
(global-set-key (kbd "<f7>")    'prev-buffer)
(global-set-key (kbd "<f8>")    'split-window-show-prev)
(global-set-key (kbd "<f9>")    'toggle-truncate-lines)
(global-set-key (kbd "M-i")     'imenu)

(global-set-key [remap backward-up-list] 'backward-up-sexp)

;; (global-set-key (kbd "M-o") 'other-window)
;; (global-unset-key (kbd "C-x C-+"))
(global-set-key (kbd "C-,") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-.") (lambda () (interactive) (other-window  1)))

(global-set-key (kbd "C-x C-+") 'text-scale-increase)
(global-set-key (kbd "C-x C--") 'text-scale-decrease)

(require 'editing-defuns)
(global-set-key (kbd "C-c C-a")  'auto-fill-mode)
(global-set-key (kbd "C-c C-w")  'subword-mode)
(global-set-key (kbd "C-c i")    'my-url-insert-file-contents)
(global-set-key (kbd "C-c n")    'tidy-region-or-buffer)
(global-set-key (kbd "C-c t")    'cycle-tab-width)
;; (global-set-key (kbd "C-x C-;")  'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-x a r")  'align-regexp)
(global-set-key (kbd "M-Z")      'zap-up-to-char)
(global-set-key (kbd "M-<up>")   'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

(define-key 'help-command (kbd "C-i") 'info-display-manual)

(global-set-key (kbd "C-c +") 'my-increment-number-at-point)
(global-set-key (kbd "C-c -") 'my-decrement-number-at-point)

;; Writing
(require 'dubcaps-mode)
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'dubcaps-mode)

(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords
             nil '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

;; Shell-mode
(setq comint-input-ignoredups t
      comint-completion-addsuffix t
      comint-completion-addsuffix t
      comint-scroll-to-bottom-on-input t
      comint-scroll-show-maximum-output t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Better C++ syntax highlighting
;; Might eventually be able to remove this
(require 'setup-cc)

;; Packages
(defvar my-packages
  '(cl-lib
    markdown-mode yaml-mode haskell-mode clojure-mode gnuplot-mode ledger-mode
    git-timemachine magit ibuffer-vc paredit
    flx-ido smex flycheck idomenu buffer-move
    password-store elfeed)
  "Packages to ensure are installed.")

;; Do this for newer Emacs
(when (or (and (= emacs-major-version 24) (>= emacs-minor-version 4))
          (>= emacs-major-version 25))
  (setq package-archives
	'(("melpa-stable" . "http://stable.melpa.org/packages/")
          ("melpa"        . "http://melpa.org/packages/")
          ("gnu"          . "http://elpa.gnu.org/packages/")))
  (package-initialize)

  (when (not package-archive-contents) (package-refresh-contents))

  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p)))

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

  ;; Smex
  (autoload 'smex "smex")
  (global-set-key (kbd "M-x") 'smex)

  ;; Ido
  (flx-ido-mode 1)
  (setq ido-enable-flex-matching t
        ido-use-virtual-buffers t)

  ;; Ibuffer
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))
  (global-set-key (kbd "C-x C-b") 'ibuffer)

  ;; Imenu
  (global-set-key (kbd "M-i") 'idomenu)

  ;; Buffer-move
  (global-set-key (kbd "<C-S-up>")     'buf-move-up)
  (global-set-key (kbd "<C-S-down>")   'buf-move-down)
  (global-set-key (kbd "<C-S-left>")   'buf-move-left)
  (global-set-key (kbd "<C-S-right>")  'buf-move-right)
  ;; (setq buffer-move-behavior 'move)

  ;; Hippie-expand
  (global-set-key [remap dabbrev-expand] 'hippie-expand)

  ;; Git
  (require 'setup-git)

  ;; Org
  (require 'setup-org)

  ;; Ledger-mode
  (add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode))

  ;; Password-store
  (global-set-key (kbd "C-c p k") 'password-store-clear)
  (global-set-key (kbd "C-c p c") 'password-store-copy)
  (global-set-key (kbd "C-c p n") 'password-store-insert)
  (global-set-key (kbd "C-c p g") 'password-store-generate)

  ;; Themes
  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes/"))

  ;; Built-in modes
  (require 'octave)
  (add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

  ;; Hidden mode line
  (require 'hidden-mode-line-mode)
  (global-set-key (kbd "<f6>") 'hidden-mode-line-mode)

  ;; Dired details
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)

  ;; Elfeed
  (setq-default elfeed-search-filter "@1-week-ago +unread -news"))

;; Load customization file last
(if (file-readable-p custom-file) (load-file custom-file))
