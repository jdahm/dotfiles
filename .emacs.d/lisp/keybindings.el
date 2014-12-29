;; keybindings.el --- My keybindings

;;; Commentary:

;;; Code:

(global-set-key (kbd "C-a")   'jdahm/beginning-of-line)

(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key (kbd "C-c s")   'shell)
(global-set-key (kbd "C-c C-a") 'auto-fill-mode)
(global-set-key (kbd "C-c C-w") 'whitespace-mode)
(global-set-key (kbd "C-c f")   'flycheck-mode)

(global-set-key (kbd "C-c t") 'jdahm/cycle-tab-width)
(global-set-key (kbd "C-c g") 'search-engine)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "C-x C-u") 'jdahm/url-insert-file-contents)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "M-#") 'sort-lines)
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)

(global-set-key (kbd "M-9") 'jdahm/switch-to-minibuffer-window)

(global-set-key (kbd "<f5>") 'jdahm/toggle-color-theme)
(global-set-key (kbd "<f6>") 'jdahm/prev-buffer)
(global-set-key (kbd "<f7>") 'jdahm/split-window)
(global-set-key (kbd "<f8>") 'jdahm/toggle-window-split)

(provide 'keybindings)

;; keybindings.el ends here
