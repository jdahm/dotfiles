(require 'helm-config)
(helm-mode 1)
(helm-autoresize-mode 1)

(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap jump-to-register]      'helm-register)
(define-key global-map [remap list-buffers]          'helm-mini)
(define-key global-map [remap dabbrev-expand]        'helm-dabbrev)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c f") 'helm-recentf)
(global-set-key (kbd "C-c g") 'helm-git-grep)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c <SPC>") 'helm-all-mark-rings)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
(global-set-key (kbd "C-h r") 'helm-info-emacs)
(global-set-key (kbd "C-h d") 'helm-info-at-point)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)
(global-set-key (kbd "M-.") 'helm-git-grep-at-point)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(define-key 'help-command (kbd "r") 'helm-info-emacs)
(define-key helm-command-map (kbd "g") 'helm-do-grep)
(define-key helm-command-map (kbd "o") 'helm-occur)
(define-key helm-command-map (kbd "C-x l") 'helm-bibtex)
(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm)

(define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
(define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point)

(setq helm-bibtex-bibliography "~/Dropbox/Papers/main.bib"
      helm-bibtex-library-path "~/Dropbox/Papers"
      helm-bibtex-notes-path "~/Dropbox/My-Notes")

(setq helm-M-x-fuzzy-match t                   ; use fuzzy M-x matching
      helm-apropos-fuzzy-match t               ; use fuzzy matching for apropos
      helm-ls-git-status-command 'magit-status ; use Magit
      helm-truncate-lines t                    ; truncate lines in buffer by default
      helm-split-window-in-side-p t            ; open helm buffer inside current window
      helm-lisp-fuzzy-completion t
      helm-completion-in-region-fuzzy-match t
      )

(provide 'setup-helm)
