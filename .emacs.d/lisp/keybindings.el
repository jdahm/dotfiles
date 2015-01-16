;; keybindings.el --- My keybindings

;;; Commentary:

;;; Code:

(global-set-key (kbd "C-a")   'my-beginning-of-line)

(global-set-key (kbd "C-'") 'er/expand-region)

(global-set-key (kbd "C-c s")   'shell)
(global-set-key (kbd "C-c f")   'flycheck-mode)
(global-set-key (kbd "C-c o")   'occur)
(global-set-key (kbd "C-c r")   'bury-buffer)
(global-set-key (kbd "C-c C-a") 'auto-fill-mode)
(global-set-key (kbd "C-c C-w") 'whitespace-mode)
(global-set-key (kbd "C-c n")   'tidy-region)
(global-set-key (kbd "C-c C-n") 'tidy-buffer)

;; Org-mode standard keybindings
(global-set-key (kbd "C-c c")   'org-capture)
(global-set-key (kbd "C-c l")   'org-store-link)
(global-set-key (kbd "C-c a")   'org-agenda)

;; Create additional scratch buffers
(global-set-key (kbd "C-c b") 'create-scratch-buffer)

(global-set-key (kbd "C-c t") 'cycle-tab-width)

;; Eval buffer
(global-set-key (kbd "C-c C-k") 'eval-buffer)

;; Search Google? why not...
(global-set-key (kbd "C-c g") 'search-engine)

(global-set-key (kbd "C-x M-f")   'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(global-set-key (kbd "C-x f")     'recentf-ido-find-file)
(global-set-key (kbd "C-x p")     'prev-buffer)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(global-set-key (kbd "C-x -") 'toggle-window-split)
(global-set-key (kbd "C-x C--") 'rotate-windows)
(global-unset-key (kbd "C-x C-+")) ;; don't zoom like this

(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "C-x C-u") 'url-insert-file-contents)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)

;; smex M-x
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; old M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Source: https://github.com/rlister/emacs.d/blob/master/lisp/window-movement.el
(global-set-key (kbd "M-n") 'other-window)
(global-set-key (kbd "M-p") 'prev-window)

;; vim's ci and co commands
(global-set-key (kbd "M-i") 'change-inner)
(global-set-key (kbd "M-o") 'change-outer)

;; Zap up to instead of over char
(global-set-key (kbd "M-z") 'zap-up-to-char)

;; Sorting
(global-set-key (kbd "M-s l") 'sort-lines)

;; Transpose line with that above or below it
(global-set-key (kbd "M-<up>")   'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; Smart comment and uncomment
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)

;; jump-char
(global-set-key (kbd "M-m")   'jump-char-forward)
(global-set-key (kbd "M-S-M") 'jump-char-backward)

(global-set-key (kbd "M-9") 'switch-to-minibuffer-window)

(global-set-key (kbd "<f5>") 'jdahm/toggle-color-theme)
(global-set-key (kbd "<f6>") 'prev-buffer)
(global-set-key (kbd "<f7>") 'split-window-show-prev)
(global-set-key (kbd "<f8>") 'toggle-window-split)
(global-set-key (kbd "<f9>") 'toggle-truncate-lines)

;; help commands
(define-key 'help-command (kbd "C-i") 'info-display-manual)

(provide 'keybindings)

;; keybindings.el ends here
