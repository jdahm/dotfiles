;;; init.el --- Configuration for Emacs
;;
;;; Author: Johann Dahm <johann.dahm@gmail.com>
;;
;;; Commentary:
;;
;; Configuration for Emacs. Requires Emacs 24 for package.el.
;;
;;; Code:

(defconst config-d "~/.config/emacs/")
(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))
(defconst backup-d (expand-file-name "backups/" user-emacs-directory))
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

(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))

;; Backups - better to be safe
(when (not (file-exists-p backup-d))
  (make-directory backup-d t))

(setq delete-by-moving-to-trash t
      backup-by-copying t      ; don't clobber symlinks
      delete-old-versions t
      backup-directory-alist `(("." . ,backup-d))
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups

;; Buffers
(winner-mode 1)

(global-set-key (kbd "C-x p") (lambda () (interactive) (other-window -1))) ; Complement to C-x o
(global-set-key (kbd "C-x |") #'toggle-window-split)

(global-set-key (kbd "C-c e") #'rgrep)
(global-set-key (kbd "C-x 9") #'bury-buffer)

;; IBuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)
(after 'ibuffer
       (require 'ibuffer-tramp)
       (require-package 'ibuffer-vc)
       (define-key ibuffer-mode-map (kbd "s r")
         #'ibuffer-tramp-set-filter-groups-by-tramp-connection)
       (define-key ibuffer-mode-map (kbd "s g")
         #'ibuffer-vc-set-filter-groups-by-vc-root)
       (add-hook 'ibuffer-hook
                 (lambda ()
                   (ibuffer-vc-set-filter-groups-by-vc-root)
                   (unless (eq ibuffer-sorting-mode 'alphabetic)
                     ;; (ibuffer-do-sort-by-alphabetic))))
                     (ibuffer-do-sort-by-vc-status)))))

(global-set-key (kbd "C-x C-a") #'align-regexp)
(global-set-key (kbd "C-M-\\") #'tidy-region-or-buffer)
(global-set-key (kbd "C-c n") #'create-scratch-buffer)
(global-set-key (kbd "C-c s") #'eshell)

;; Editing
(global-set-key (kbd "M-Q") #'unfill-paragraph)
(global-set-key (kbd "M-y") #'yank-pop)
(global-set-key (kbd "C-c y") (lambda () (interactive) (popup-menu 'yank-menu)))

(global-set-key (kbd "C-c f") #'prelude-copy-file-name-to-clipboard)

;; This overwrites `comment-set-column', but that is rarely used and
;; the default binding for comment-line is not terminal-friendly.
(global-set-key (kbd "C-x ;") #'comment-line)

(global-set-key (kbd "C-c +") #'inc-number-at-point)
(global-set-key (kbd "C-c -") #'dec-number-at-point)

;; Recentf -- run every 10 minutes
(recentf-mode 1)
;; This overwrites `isearch-backward-regexp' but that is virtually
;; never needed.
(global-set-key (kbd "C-M-r") #'recentf-open-files)
;; (run-at-time nil (* 10 60) #'recentf-save-list)

;; Dired
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(global-set-key (kbd "C-x C-j") #'dired-jump)
(global-set-key (kbd "C-x 4 C-j") #'dired-jump-other-window)
(setq-default dired-clean-up-buffers-too t
              dired-recursive-copies 'always
              dired-recursive-deletes 'top)
(autoload #'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload #'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)

(after 'dired
       (require 'jd-dired)
       (define-key dired-mode-map (kbd "C-c s") #'sudired)
       (define-key dired-mode-map "b" #'dired-open-file)
       (define-key dired-mode-map "c" #'dired-open-fm)
       (define-key dired-mode-map "e" #'ora-ediff-files)
       (define-key dired-mode-map "Q" #'dired-do-query-replace-regexp))

;; Shell
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

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

;; Compile
(global-set-key (kbd "<f9>") #'compile)

;; Source: purcell/emacs.d
(defvar jdahm/last-compilation-buffer nil
  "The last buffer in which compilation took place.")

(after 'compile
  (defadvice compilation-start (after jdahm/save-compilation-buffer activate)
    "Save the compilation buffer to find it later."
    (setq jdahm/last-compilation-buffer next-error-last-buffer))

  (defadvice compile (around use-bashrc activate)
    "Load .bashrc in any calls to bash (e.g. so we can use aliases)"
    (let ((shell-command-switch "-lc"))
      ad-do-it))

  (defadvice recompile (around jdahm/find-prev-compilation-use-bash (&optional edit-command) activate)
    "Load .bashrc in any calls to bash (e.g. so we can use aliases)"
    (let ((shell-command-switch "-lc"))
      (if (and (null edit-command)
               (not (derived-mode-p 'compilation-mode))
               jdahm/last-compilation-buffer
               (buffer-live-p (get-buffer jdahm/last-compilation-buffer)))
          (with-current-buffer jdahm/last-compilation-buffer
            ad-do-it)
        ad-do-it))))

;; Macros
(global-set-key (kbd "C-c m") #'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "C-z") #'kmacro-end-or-call-macro)
(global-set-key (kbd "<f5>") #'save-kbd-macro)

;; Octave
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

;; C/C++
(after 'prog (define-key prog-mode-map (kbd "C-c w") #'whitespace-mode))
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\|\\MISSING\\)" 1 font-lock-warning-face t)))))

(require-package 'modern-cpp-font-lock)
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
(add-hook 'c-mode-common-hook (lambda () (define-key c-mode-base-map (kbd "M-o") #'ff-find-other-file)))

;; CUDA
(dolist (item '(("\\.cu\\'" . c++-mode)
                ("\\.cuh\\'" . c++-mode)))
  (add-to-list 'auto-mode-alist item))

(c-set-offset 'innamespace 0) ; Don't indent after namespaces

;; Git and VC
;; These are distributed with git: contrib/emacs/git{,-blame}.el
(autoload #'git-status "git""An interface to git." t)
(autoload #'git-blame-mode "git-blame" "Minor mode for incremental blame for Git." t)
(global-set-key (kbd "C-c g") #'git-status)
(global-set-key (kbd "C-c j") #'vc-git-grep)

;; Flyspell
(require 'flyspell)
(add-hook 'text-mode-hook #'turn-on-flyspell)
(after 'flyspell
  (define-key flyspell-mode-map (kbd "<C-f12>") 'flyspell-goto-next-error))
(after 'auto-complete (ac-flyspell-workaround))

;; Org
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c b") #'org-iswitchb)
(add-hook 'org-mode-hook #'turn-on-visual-line-mode)
(add-hook 'org-mode-hook #'turn-on-flyspell)

;; Auctex
(require-package 'auctex)
(require-package 'auctex-latexmk)
(auctex-latexmk-setup)

(add-to-list 'auto-mode-alist '("\\.tex$" . LaTeX-mode))
;; Source: https://thenybble.de/projects/inhibit-auto-fill.html
;; Inhibiting auto-fill
(defcustom LaTeX-inhibited-auto-fill-environments
  '("tabular" "tikzpicture") "For which LaTeX environments not to run auto-fill.")
(defun LaTeX-limited-auto-fill ()
  (let ((environment (LaTeX-current-environment)))
    (when (not (member environment LaTeX-inhibited-auto-fill-environments))
      (do-auto-fill))))
(add-hook 'LaTeX-mode-hook
          (lambda () (setq auto-fill-function #'LaTeX-limited-auto-fill)) t)

;; Inhibit breaking on non-breaking space
(defun LaTeX-dont-break-on-nbsp ()
  (and (eq major-mode 'latex-mode)
       (eq (char-before (- (point) 1)) ?\\)))
(add-to-list 'fill-nobreak-predicate #'LaTeX-dont-break-on-nbsp)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (LaTeX-math-mode 1)
            (reftex-mode 1)))

;; Source: http://www.cs.au.dk/~abizjak/emacs/2016/03/06/latex-fill-paragraph.html
(defun tex/fill-paragraph (&optional P)
  "When called with prefix argument call `fill-paragraph'.
Otherwise split the current paragraph into one sentence per line."
  (interactive "P")
  (if (not P)
      (save-excursion
        (let ((fill-column 12345678)) ;; relies on dynamic binding
          (fill-paragraph) ;; this will not work correctly if the paragraph is
                           ;; longer than 12345678 characters (in which case the
                           ;; file must be at least 12MB long. This is unlikely.)
          (let ((end (save-excursion
                       (forward-paragraph 1)
                       (backward-sentence)
                       (point-marker))))  ;; remember where to stop
            (beginning-of-line)
            (while (progn (forward-sentence)
                          (<= (point) (marker-position end)))
              (just-one-space) ;; leaves only one space, point is after it
              (delete-char -1) ;; delete the space
              (newline)        ;; and insert a newline
              (LaTeX-indent-line) ;; I only use this in combination with late, so this makes sense
              ))))
    ;; otherwise do ordinary fill paragraph
    (fill-paragraph P)))

(define-key LaTeX-mode-map (kbd "M-q") #'tex/fill-paragraph)

;; Mode line and title
(setq-default mode-line-format
              '(((:eval (let* ((buffer-name (concat
                                             (propertize (buffer-name) 'face '(:weight bold))
                                             ":" (propertize (format-mode-line "%l,%c") 'face '(:weight light))))
                               (left (concat (format-mode-line mode-line-front-space)
                                             "(" (if (buffer-modified-p) "⋯" "✓") ")"

                                             " "
                                             (format "%-15s" buffer-name)
                                             "    "
                                             (if vc-mode (concat vc-mode " (" (symbol-name (vc-state (buffer-file-name))) ")") "")
                                             "  "
                                             (format-mode-line mode-line-misc-info)))
                               (right (concat "("
                                              (propertize (format-mode-line mode-name) 'face '(:weight bold))
                                              (format-mode-line minor-mode-alist)
                                              ")"
                                              (format-mode-line mode-line-end-spaces)))
                               (padding (make-string (max 0 (- (window-width) 4 (length left) (length right))) ? )))
                          (format "%s %s %s" left padding right))))))

(add-hook 'after-init-hook
          (lambda ()
            (setq frame-title-format
                  '(buffer-file-name
                    "%f"
                    (dired-directory dired-directory "%b")))))

;; Whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Tramp ssh control is correctly setup in ~/.ssh/config
;; Source: https://lists.gnu.org/archive/html/help-gnu-emacs/2013-04/msg00323.html
(setq tramp-ssh-controlmaster-options "")

;; Use shell-like backspace C-h, rebind help to F1
;; Source: magnars/hardcore-mode.el
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "C-x ?") 'help-command)
(global-set-key (kbd  "<f1>") 'help-command)

;; Themes
(add-to-list 'load-path (expand-file-name "themes/" user-emacs-directory))

;; Load custom file
(if (file-readable-p custom-file) (load-file custom-file))

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
