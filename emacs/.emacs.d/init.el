(defvar emacs-d "~/.emacs.d")
(defvar config-d "~/.config/emacs/")
(defvar lisp-d (expand-file-name "lisp/" emacs-d))

;; Initialize package system
(setq package-archives
    '(("gnu" . "http://elpa.gnu.org/packages/")
      ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;;; Fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

(defvar jdahm/package-list
  '(markdown-mode
    yaml-mode
    haskell-mode
    clojure-mode
    gnuplot-mode
    ledger-mode
    web-mode
    transpose-frame
    ibuffer-vc
    swiper
    counsel
    avy
    company
    flycheck
    magit
    git-timemachine
    projectile
    function-args
    engine-mode
    org-present
    zenburn-theme))

;; Install packages
(dolist (p jdahm/package-list)
  (unless (package-installed-p p)
    (package-install p)))

(prefer-coding-system 'utf-8)

(defalias 'yes-or-no-p 'y-or-n-p)

(add-hook 'after-init-hook
          (lambda ()
            (setq frame-title-format
                  '(buffer-file-name
                    "%f"
                    (dired-directory dired-directory "%b")))))

(windmove-default-keybindings)

(load-file (expand-file-name "buffer.el" lisp-d))
(global-set-key (kbd "C-x a b") 'create-scratch-buffer)

(global-set-key (kbd "C-,") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-.") (lambda () (interactive) (other-window +1)))

(load-file (expand-file-name "editing.el" lisp-d))
(global-set-key (kbd "C-c n") 'tidy-region-or-buffer)
(global-set-key (kbd "C-x a r") 'align-regexp)

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

(global-set-key (kbd "C-c +") 'my-increment-number-at-point)
(global-set-key (kbd "C-c -") 'my-decrement-number-at-point)

(require 'dired)
(load-file (expand-file-name "dired.el" lisp-d))
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(define-key dired-mode-map "b" 'dired-open-file)
(define-key dired-mode-map "c" 'dired-open-fm)

;; Help
(define-key 'help-command (kbd "C-i") 'info-display-manual)
(define-key 'help-command (kbd "C-k") 'customize-apropos)

;; Shell
(require 'shell)
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)
(global-set-key (kbd "C-c s") 'shell)

;; Completion
(require 'counsel)
(global-set-key (kbd "C-S-s") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "M-y") 'counsel-yank-pop)

;; Avy
(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g a") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)

;; Function-args
(fa-config-default)

;; Web-mode
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))

;; Magit
(add-hook 'magit-mode-hook #'magit-load-config-extensions)
(global-set-key (kbd "C-x g") 'magit-status)

(add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))

(require 'octave)
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(require 'engine-mode)
(defengine duckduckgo
  "https://duckduckgo.com/?q=%s"
  :keybinding "d")
(defengine github
  "https://github.com/search?ref=simplesearch&q=%s"
  :keybinding "g")
(defengine cppreference
  "http://en.cppreference.com/mwiki/index.php?search=%s"
  :keybinding "c")
(defengine stack-overflow
  "https://stackoverflow.com/search?q=%s"
  :keybinding "s")

(require 'org)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(add-hook 'org-present-mode-hook
          (lambda ()
            (org-present-big)
            (org-display-inline-images)
            (org-present-hide-cursor)
            (org-present-read-only)))
(add-hook 'org-present-mode-quit-hook
          (lambda ()
            (org-present-small)
            (org-remove-inline-images)
            (org-present-show-cursor)
            (org-present-read-write)))

(load-file (expand-file-name "cc.el" lisp-d))
(add-hook 'c++-mode-hook (lambda ()
                           (c-set-style "stroustrup")
                           (c-set-offset 'namespace-open 0)
                           (c-set-offset 'namespace-close 0)
                           (c-set-offset 'innamespace 0)))
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

(add-hook 'prog-mode-hook #'company-mode)
(add-hook 'prog-mode-hook #'flycheck-mode)

(global-set-key (kbd "C-c m") 'projectile-compile-project)

(setq custom-file (expand-file-name "custom.el" config-d))
(load-file custom-file)
