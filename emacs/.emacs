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
;;   * bbatsov/emacs.d
;;
;;; Code:

(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))
(defconst backup-d (expand-file-name "backups/" user-emacs-directory))
(defconst themes-d (expand-file-name "themes/" user-emacs-directory))

;; -------------------- Package.el --------------------
;; Prefer newer versions of files
(setq load-prefer-newer t)

;; Set package archives and initialize
(require 'package)
(dolist (source '(("org" . "https://orgmode.org/elpa/")
                  ("melpa" . "https://melpa.org/packages/")
                  ))
  (add-to-list 'package-archives source t))

(unless package--initialized (package-initialize))

(defun require-package (package)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; -------------------- Buffer Management --------------------
(defun create-scratch-buffer nil
  "create a scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun toggle-window-split ()
  "Toggle between horizontal and vertical splits."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

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

;; -------------------- Editing Commands --------------------
(global-set-key (kbd "C-x C-a") #'align-regexp)

(defun tidy-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
    (if (region-active-p)
        (progn
	  (delete-trailing-whitespace (region-beginning) (region-end))
          (indent-region (region-beginning) (region-end) nil)
	  (untabify (point-min) (point-max)))
      (progn
	(delete-trailing-whitespace)
	(indent-region (point-min) (point-max) nil)
	(untabify (point-min) (point-max)))))
(global-set-key (kbd "C-M-\\") #'tidy-region-or-buffer)

;; Stefan Monnier <foo at acm.org>. Opposite of `fill-paragraph'
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
	;; This would override `fill-column' if it's an integer.
	(emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))
(global-set-key (kbd "M-Q") #'unfill-paragraph)

(require-package 'emojify)
(add-hook 'after-init-hook #'global-emojify-mode)

(require-package 'bool-flip)
(global-set-key (kbd "C-c b") #'bool-flip-do-flip)

;; delete the active region with DEL
(delete-selection-mode t)

;; This overwrites `comment-set-column', but that is rarely used and
;; the default binding for comment-line is not terminal-friendly.
(global-set-key (kbd "C-x ;") #'comment-line)

(global-set-key (kbd "C-c +") #'inc-number-at-point)
(global-set-key (kbd "C-c -") #'dec-number-at-point)

;; Recentf
(global-set-key (kbd "C-M-r") #'recentf-open-files)

;; -------------------- Text --------------------
(require-package 'markdown-mode)
(dolist (item '(("README\\.md\\'" . gfm-mode)
                ("\\.md\\'" . markdown-mode)
                ("\\.markdown\\'" . markdown-mode)))
  (add-to-list 'auto-mode-alist item))

;; Spelling
(require 'flyspell)
(add-hook 'text-mode-hook #'turn-on-flyspell)

(with-eval-after-load 'flyspell
  (define-key flyspell-mode-map (kbd "<C-f12>") #'flyspell-goto-next-error))

(with-eval-after-load 'auto-complete (ac-flyspell-workaround))

;; Conf mode for .job files
(add-to-list 'auto-mode-alist '("\\.job\\'" . conf-mode))

;; -------------------- Programming --------------------
;; Completion
(require-package 'company)
(add-hook 'after-init-hook 'global-company-mode)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; Compile
(global-set-key (kbd "C-c m") #'compile)

;; Programming mode mappings
(define-key prog-mode-map (kbd "M-`") #'imenu)
(define-key prog-mode-map (kbd "M-o") #'ff-find-other-file)

;; Whitespace
(defvar jdahm/inhibit-dtw nil)
(defun jdahm/delete-trailing-whitespace ()
  (unless jdahm/inhibit-dtw (delete-trailing-whitespace)))
(add-hook 'before-save-hook #'jdahm/delete-trailing-whitespace)

(defun jdahm/inhibit-dtw ()
  (interactive)
  (set (make-local-variable 'jdahm/inhibit-dtw) t))

;; -------------------- Dired --------------------
;; Use a replacement ls
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

;; vim-style increment/decrement numbers
;; Source: https://gist.github.com/d11wtq/5836174
(defun inc-number-at-point (n)
  "Increment the number under the point, if present.
Called with a prefix argument, changes the number by N."
  (interactive "p")
  (let ((amt (or n 1))
        (word (thing-at-point 'word))
        (bounds (bounds-of-thing-at-point 'word)))
    (when (string-match "^[0-9]+$" word)
      (replace-string word
                      (format "%d" (+ amt (string-to-int word)))
                      nil (car bounds) (cdr bounds))
      (forward-char -1))))

(defun dec-number-at-point (n)
  "Increment number at point like vim's C-a"
  (interactive "p")
  (inc-number-at-point (- n)))

(defun dired-open-fm ()
  "Open a GUI file manager at (dired-current-directory) using
xdg-open."
  (interactive)
  (if (string-equal system-type "darwin")
      (call-process "open" nil 0 nil (dired-current-directory))
    (call-process "xdg-open" nil 0 nil (dired-current-directory))))

(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (if (string-equal system-type "darwin")
	(call-process "open" nil 0 nil file)
      (call-process "xdg-open" nil 0 nil file))
    (message "Opening %s done" file)))

(with-eval-after-load 'dired
  (define-key dired-mode-map "b" #'dired-open-file)
  (define-key dired-mode-map "c" #'dired-open-fm)
  (define-key dired-mode-map "Q" #'dired-do-query-replace-regexp))

;; -------------------- Shell --------------------
(global-set-key (kbd "C-c s") #'eshell)
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

;; -------------------- Web --------------------
(require-package 'web-mode)
(require-package 'ssass-mode)
(dolist (item '(("\\.html?\\'" . web-mode)
                ("\\.css?\\'" . web-mode)))
  (add-to-list 'auto-mode-alist item))

;; -------------------- Compiled languages --------------------
(require-package 'modern-cpp-font-lock)
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)

(c-add-style "mybsd" '("bsd"
                       (c-offsets-alist
                        (inlambda . 0) ; no extra indent for lambda
                        (innamespace . 0)))) ; no indent for namespaces

(require-package 'cmake-mode)
(require-package 'cmake-project)

(require-package 'cuda-mode)
(require-package 'rust-mode)

;; c-mode for okl
(add-to-list 'auto-mode-alist '("\\.okl\\'" . c-mode))

;; -------------------- Dev Ops --------------------
(require-package 'dockerfile-mode)

;; -------------------- Version tracking --------------------
(require-package 'hl-todo)
(global-hl-todo-mode)

(require-package 'magit)
(global-set-key (kbd "C-c g") #'magit-status)

;; -------------------- Global toggle mapping --------------------
;; Source: http://endlessparentheses.com/the-toggle-map-and-wizardry.html
(define-prefix-command 'jd/toggle-map)
;; The manual recommends C-c for user keys, but C-x t is
;; always free, whereas C-c t is used by some modes.
(global-set-key (kbd "C-c t") #'jd/toggle-map)
(define-key jd/toggle-map "a" #'auto-fill-mode)
(define-key jd/toggle-map "c" #'column-number-mode)
(define-key jd/toggle-map "d" #'toggle-debug-on-error)
(define-key jd/toggle-map "f" #'focus-mode)
(define-key jd/toggle-map "t" #'toggle-truncate-lines)
(define-key jd/toggle-map "l" #'linum-mode)
(define-key jd/toggle-map "s" #'subword-mode)
(define-key jd/toggle-map "S" #'superword-mode)
(define-key jd/toggle-map "q" #'toggle-debug-on-quit)
(define-key jd/toggle-map "r" #'dired-toggle-read-only)
(autoload 'dired-toggle-read-only "dired" nil t)
(define-key jd/toggle-map "w" #'whitespace-mode)
(define-key jd/toggle-map "|" #'toggle-window-split)

;; Tramp ssh control is correctly setup in ~/.ssh/config
;; Source: https://lists.gnu.org/archive/html/help-gnu-emacs/2013-04/msg00323.html
(setq tramp-ssh-controlmaster-options "")

;; Disable version control to avoid delays
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

;; Org
(defconst jd-default-notes-file "~/Documents/todo.org")
(defconst jd-diary-file "~/Documents/diary.org")

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)
(add-hook 'org-mode-hook #'turn-on-visual-line-mode)
(add-hook 'org-mode-hook #'turn-on-flyspell)

;; -------------------- LaTeX --------------------
(require-package 'auctex)
(require-package 'auctex-latexmk)
(auctex-latexmk-setup)

(defun auctex-fill-sentence ()
  (interactive)
  (save-excursion
    (or (eq (point) (point-max)) (forward-char))
    (forward-sentence -1)
    (indent-relative t)
    (let ((beg (point))
          (ix (string-match "LaTeX" mode-name)))
      (forward-sentence)
      (if (and ix (equal "LaTeX" (substring mode-name ix)))
          (LaTeX-fill-region-as-paragraph beg (point))
        (fill-region-as-paragraph beg (point))))))

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (define-key LaTeX-mode-map (kbd "M-j") #'auctex-fill-sentence)
            (visual-line-mode 1)
            (LaTeX-math-mode 1)
            (reftex-mode 1)))

;; -------------------- Feed Reader --------------------
(let ((feeds-file "~/feeds.el"))
  (when (file-exists-p feeds-file)
    (require-package 'elfeed)
    (load-file feeds-file)
    (global-set-key (kbd "C-x w") 'elfeed)))

;; -------------------- Appearance --------------------
;; Zenburn theme
(require-package 'zenburn-theme)

;; Use variable-pitch fonts for some headings and titles
(setq zenburn-use-variable-pitch t)
;; Scale headings in org-mode
(setq zenburn-scale-org-headlines t)
;; Scale headings in outline-mode
(setq zenburn-scale-outline-headlines t)

;; Fancy titlebar for MacOS
;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

;; Frame title = absolute path to file (if exists)
(setq frame-title-format
      '(buffer-file-name "%f"
        (dired-directory dired-directory "%b")))

;; Dark titlebar
(add-to-list 'default-frame-alist '(ns-appearance . dark))

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
 '(beginend-global-mode t)
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
 '(company-backends
   (quote
    (company-capf company-dabbrev-code company-abbrev company-etags company-dabbrev)))
 '(compilation-message-face (quote default))
 '(compilation-scroll-output (quote first-error))
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("04232a0bfc50eac64c12471607090ecac9d7fd2d79e388f8543d1c5439ed81f5" default)))
 '(custom-theme-directory themes-d)
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
 '(magit-blame-mode-lighter "🔥")
 '(magit-diff-refine-hunk t)
 '(markdown-command "multimarkdown")
 '(midnight-mode t)
 '(org-agenda-files jd-default-notes-file)
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file+headline "~/Documents/todo.org" "Tasks")
      "* TODO %?
  %i
  %a")
     ("l" "Log" entry
      (file+olp+datetree "~/Documents/todo.org" "Log")
      "* %?%i" :clock-in t :clock-keep t :tree-type week))))
 '(org-clock-idle-time 45)
 '(org-default-notes-file jd-default-notes-file)
 '(org-directory "~/org/")
 '(org-log-done (quote time))
 '(package-selected-packages
   (quote
    (elfeed bool-flip ssass-mode dockerfile-mode emojify rust-mode cuda-mode cmake-mode auctex-latexmk auctex modern-cpp-font-lock magit hl-todo web-mode markdown-mode olivetti company ibuffer-vc ibuffer-tramp)))
 '(recentf-max-menu-items 25)
 '(recentf-mode t)
 '(remote-file-name-inhibit-cache 3600)
 '(ring-bell-function (quote ignore))
 '(savehist-mode t)
 '(scroll-bar-mode nil)
 '(sentence-end-double-space nil)
 '(set-mark-command-repeat-pop t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tramp-completion-reread-directory-timeout 3600 nil (tramp))
 '(tramp-connection-timeout 5 nil (tramp))
 '(use-dialog-box nil)
 '(use-file-dialog nil)
 '(version-control t)
 '(visible-bell nil)
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
