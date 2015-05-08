(require 'mu4e)
(require 'smtpmail)

(setq user-full-name "Johann Dahm"
      mu4e-maildir (expand-file-name "~/Mail")
      mu4e-attachment-dir (expand-file-name "~/Downloads")
      mu4e-get-mail-command "mbsync -q -a"
      mu4e-view-show-images t
      mu4e-view-image-max-width 800
      ;; mu4e-update-interval 300 ; No automatic updates
      mu4e-change-filenames-when-moving t
      mu4e-view-show-addresses t
      ;; mu4e-use-fancy-chars t ; These are ugly!
      mu4e-drafts-folder "/Drafts"
      mu4e-trash-folder "/Trash"
      mu4e-msg2pdf "/usr/bin/msg2pdf"
      mu4e-compose-signature-auto-include nil) ;; include with C-c C-w

(setq mu4e-html2text-command
      "html2text --body-width=72 --images-to-alt --protect-links")

(add-to-list 'mu4e-view-actions
             '("View in browser" . mu4e-action-view-in-browser) t)

;; Send with smtpmail and kill the buffer
(setq message-send-mail-function 'smtpmail-send-it
      message-kill-buffer-on-exit t)

(defun create-home-signature (addr)
  (concat "Johann Dahm <" addr ">"
          "http://johanndahm.com | 734.476.8606 (c)"
          "PGP: 4320 C3EF CDB1 863B 4922  F8AD 4912 E1CF EC5A 99B3"))

(defun create-work-signature (addr)
  (concat "Johann P.S. Dahm <" addr ">"
          "Ph.D. Candidate"
          "Department of Aerospace Engineering, University of Michigan"
          "2001 François-Xavier Bagnoud Building"
          "www.johanndahm.com | 734.476.8606 (c)"))

(defun create-fm-vars (mail-address)
  "Return account-vars for fm given MAIL-ADDRESS."
  (mapc 'list `((mu4e-sent-folder "/fm/Sent Items")
                (mu4e-compose-signature ,(create-home-signature mail-address))
                (user-mail-address ,mail-address)
                (mu4e-sent-messages-behavior sent)
                (smtpmail-smtp-user "jdahm@fastmail.com")
                (smtpmail-smtp-server "mail.messagingengine.com")
                (smtpmail-stream-type starttls)
                (smtpmail-smtp-service 587))))

(defun create-gmail-vars (mail-address)
  "Return account-vars for gmail given MAIL-ADDRESS."
  (mapc 'list `((mu4e-sent-folder "/um/Sent Mail")
                (mu4e-compose-signature ,(create-work-signature mail-address))
                (user-mail-address ,mail-address)
                (mu4e-sent-messages-behavior delete)
                (smtpmail-smtp-user ,mail-address)
                (smtpmail-smtp-server "smtp.gmail.com")
                (smtpmail-stream-type starttls)
                (smtpmail-smtp-service 587))))

;; Account alist
(defvar my-mu4e-account-alist
  (list (cons "johann@dahm.co" (create-fm-vars "johann@dahm.co"))
        (cons "jdahm@fastmail.com" (create-fm-vars "jdahm@fastmail.com"))
        (cons "jdahm@umich.edu" (create-gmail-vars "jdahm@umich.edu"))))

;; Set default account
(mapc #'(lambda (var) (set (car var) (cadr var))) (cdr (car my-mu4e-account-alist)))

;; Set my addresses
(setq mu4e-user-mail-address-list (mapcar 'car my-mu4e-account-alist))

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
          (completing-read (format "Compose with account: (%s) "
                                   (mapconcat #'(lambda (var) (car var))
                                              my-mu4e-account-alist "/"))
                           (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                           nil t nil nil (caar my-mu4e-account-alist)))
         (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

;; GPG
(add-hook 'mu4e-compose-mode-hook 'epa-mail-mode)
(add-hook 'mu4e-view-mode-hook 'epa-mail-mode)

;; Composing
(add-hook 'mu4e-compose-mode-hook
          (defun my-compose-settings ()
            (set-fill-column 72)
            (flyspell-mode)))

;; Attaching files via dired
;; Source: http://www.djcbsoftware.nl/code/mu/mu4e/Attaching-files-with-dired.html
(require 'gnus-dired)
;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
	(set-buffer buffer)
	(when (and (derived-mode-p 'message-mode)
		(null message-sent-message-via))
	  (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

(setq mu4e-headers-fields
  '( (:human-date    .   12)
     (:flags         .    6)
     (:maildir       .   12)
     (:from          .   20)
     (:subject       .   nil)))

(global-set-key (kbd "C-c u") 'mu4e-update-mail-and-index)
