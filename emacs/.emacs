;;; .emacs --- Configuration for Emacs
;;
;;; Author: Johann Dahm <johann.dahm@gmail.com>
;;
;;; Commentary:
;;
;; Configuration for Emacs. Requires Emacs 24 for package.el.
;;
;; Sources:
;;   * sjrmanning/.emacs.d
;;   * magnars/.emacs.d
;;   * muahah/emacs-profile
;;
;;; Code:

(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))
(defconst backup-d (expand-file-name "backups/" user-emacs-directory))

;; Set package archives and initialize
(require 'package)
(let* ((ssl (gnutls-available-p))
       (proto (if ssl "https://" "http://")))
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "stable.melpa.org/packages/")) t))
(package-initialize)

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; Some extra functions
(require 'jd-extra)

;; Complement to C-x o
(global-set-key (kbd "C-x p") (lambda () (interactive) (other-window -1)))

(autoload 'ibuffer "ibuffer" "ibuffer mode" t)
(global-set-key (kbd "C-x C-b") #'ibuffer)

(require-package 'ibuffer-tramp)
(require-package 'ibuffer-vc)

(with-eval-after-load 'ibuffer
  (define-key ibuffer-mode-map (kbd "s r") #'ibuffer-tramp-set-filter-groups-by-tramp-connection)
  (define-key ibuffer-mode-map (kbd "s g") #'ibuffer-vc-set-filter-groups-by-vc-root)
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                ;; (ibuffer-do-sort-by-alphabetic))))
                (ibuffer-do-sort-by-vc-status)))))

(global-set-key (kbd "C-x C-a") #'align-regexp)
(global-set-key (kbd "C-M-\\") #'tidy-region-or-buffer)
(global-set-key (kbd "C-c s") #'eshell)

;; Editing
(global-set-key (kbd "M-Q") #'unfill-paragraph)

;; This overwrites `comment-set-column', but that is rarely used and
;; the default binding for comment-line is not terminal-friendly.
(global-set-key (kbd "C-x ;") #'comment-line)

(global-set-key (kbd "C-c +") #'inc-number-at-point)
(global-set-key (kbd "C-c -") #'dec-number-at-point)

;; Recentf
(global-set-key (kbd "C-M-r") #'recentf-open-files)

;; Dired
(setq ls-lisp-use-insert-directory-program nil)
(require 'ls-lisp)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(global-set-key (kbd "C-x C-j") #'dired-jump)
(global-set-key (kbd "C-x 4 C-j") #'dired-jump-other-window)
(setq-default dired-recursive-copies 'always
              dired-recursive-deletes 'top)
(autoload #'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload #'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)

(with-eval-after-load 'dired
  (define-key dired-mode-map "b" #'dired-open-file)
  (define-key dired-mode-map "c" #'dired-open-fm)
  (define-key dired-mode-map "Q" #'dired-do-query-replace-regexp))

;; Shell
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

;; Text and Web
(require-package 'olivetti)

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

;; Compile
(global-set-key (kbd "<f9>") #'compile)

;; Git
(require-package 'hl-todo)
(global-hl-todo-mode)
(require-package 'magit)
(global-set-key (kbd "C-x g") #'magit-status)
(add-hook 'magit-update-uncommitted-buffer-hook 'vc-refresh-state)

;; Programming
(define-key prog-mode-map (kbd "M-`") #'imenu)
(global-set-key (kbd "M-o") #'ff-find-other-file)

;; C/C++
(require-package 'modern-cpp-font-lock)
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)

(c-add-style "mybsd" '("bsd"
                       (c-offsets-alist
                        (inlambda . 0) ; no extra indent for lambda
                        (innamespace . 0)))) ; no indent for namespaces

;; Source: http://endlessparentheses.com/the-toggle-map-and-wizardry.html
(define-prefix-command 'jd/toggle-map)
;; The manual recommends C-c for user keys, but C-x t is
;; always free, whereas C-c t is used by some modes.
(global-set-key (kbd "C-c t") #'jd/toggle-map)
(define-key jd/toggle-map "c" #'column-number-mode)
(define-key jd/toggle-map "d" #'toggle-debug-on-error)
(define-key jd/toggle-map "f" #'auto-fill-mode)
(define-key jd/toggle-map "t" #'toggle-truncate-lines)
(define-key jd/toggle-map "l" #'linum-mode)
(define-key jd/toggle-map "s" #'subword-mode)
(define-key jd/toggle-map "S" #'superword-mode)
(define-key jd/toggle-map "q" #'toggle-debug-on-quit)
(define-key jd/toggle-map "r" #'dired-toggle-read-only)
(autoload 'dired-toggle-read-only "dired" nil t)
(define-key jd/toggle-map "w" #'whitespace-mode)
(define-key jd/toggle-map "|" #'toggle-window-split)

;; Whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Tramp ssh control is correctly setup in ~/.ssh/config
;; Source: https://lists.gnu.org/archive/html/help-gnu-emacs/2013-04/msg00323.html
(setq tramp-ssh-controlmaster-options "")

;; Disable version control to avoid delays
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

;; Spelling
(require 'flyspell)
(add-hook 'text-mode-hook #'turn-on-flyspell)
(with-eval-after-load 'flyspell
  (define-key flyspell-mode-map (kbd "<C-f12>") #'flyspell-goto-next-error))
(with-eval-after-load 'auto-complete (ac-flyspell-workaround))

;; Org
(defconst jd-default-notes-file "~/Documents/todo.org")
(defconst jd-diary-file "~/Documents/diary.org")

(require-package 'org-plus-contrib)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)
(add-hook 'org-mode-hook #'turn-on-visual-line-mode)
(add-hook 'org-mode-hook #'turn-on-flyspell)

;; Auctex
(require-package 'auctex)
(require-package 'auctex-latexmk)
(auctex-latexmk-setup)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (LaTeX-math-mode 1)
            (reftex-mode 1)))

;; Other modes
(require-package 'cmake-mode)
(require-package 'cuda-mode)
(require-package 'rust-mode)

;; Conf mode for .job files
(add-to-list 'auto-mode-alist '("\\.job\\'" . conf-mode))

;; c-mode for okl
(add-to-list 'auto-mode-alist '("\\.okl\\'" . c-mode))

;; Fancy titlebar for MacOS
;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
;; (add-to-list 'default-frame-alist '(ns-appearance . dark))
(add-hook 'after-init-hook
          (lambda ()
            (setq frame-title-format
                  '(buffer-file-name
                    "%f"
                    (dired-directory dired-directory "%b")))))

;; Enable disabled functions
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(TeX-auto-save nil)
 '(TeX-engine (quote luatex))
 '(TeX-parse-self t)
 '(backup-by-copying t)
 '(backup-directory-alist (\` (("." \, backup-d))))
 '(blink-cursor-mode nil)
 '(bury-successful-compilation-precompile-window-state t)
 '(bury-successful-compilation-save-windows t)
 '(c-default-style
   (quote
    ((java-mode . "java")
     (awk-mode . "awk")
     (other . "mybsd"))))
 '(column-number-mode t)
 '(comint-input-ignoredups t)
 '(comint-prompt-read-only t)
 '(comint-scroll-show-maximum-output nil)
 '(comint-scroll-to-bottom-on-input (quote all))
 '(compilation-message-face (quote default))
 '(compilation-scroll-output (quote first-error))
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "bfdcbf0d33f3376a956707e746d10f3ef2d8d9caa1c214361c9c08f00a1c8409" default)))
 '(delete-by-moving-to-trash t)
 '(delete-old-versions t)
 '(ediff-cmp-options (quote ("-w")))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(enable-remote-dir-locals t)
 '(ibuffer-saved-filter-groups nil)
 '(ibuffer-saved-filters
   (quote
    (("only-files"
      ((not mode . dired-mode)
       (name . "^[^*]")))
     ("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode)))))))
 '(ibuffer-use-other-window t)
 '(indent-tabs-mode nil)
 '(initial-scratch-message "")
 '(ispell-program-name "/usr/local/bin/aspell")
 '(midnight-mode t)
 '(org-agenda-files jd-default-notes-file)
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file org-default-notes-file)
      "* TODO %?\\n%u\\n%a\\n")
     ("m" "Meeting" entry
      (file org-default-notes-file)
      "* MEETING with %? :MEETING:
%t")
     ("d" "Diary" entry
      (file+datetree jd-diary-file))
     ("i" "Idea" entry
      (file org-default-notes-file)
      "* %? :IDEA: \\n%t")
     ("n" "Next Task" entry
      (file+headline org-default-notes-file "Tasks")
      "** NEXT %?
DEADLINE: %t"))))
 '(org-clock-idle-time 45)
 '(org-default-notes-file jd-default-notes-file)
 '(org-directory "~/org/")
 '(org-log-done (quote time))
 '(package-selected-packages
   (quote
    (zenburn-theme web-mode solarized-theme rust-mode projectile org-plus-contrib olivetti modern-cpp-font-lock markdown-mode magit ibuffer-vc ibuffer-tramp hl-todo cuda-mode cmake-mode auctex-latexmk)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(recentf-max-menu-items 25)
 '(recentf-mode t)
 '(remote-file-name-inhibit-cache 3600)
 '(savehist-mode t)
 '(scroll-bar-mode nil)
 '(sentence-end-double-space nil)
 '(set-mark-command-repeat-pop t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tramp-completion-reread-directory-timeout 3600 nil (tramp))
 '(use-dialog-box nil)
 '(use-file-dialog nil)
 '(version-control t)
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 140 :family "Ubuntu Mono"))))
 '(variable-pitch ((t (:family "ETBembo")))))
