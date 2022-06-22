(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-enabled-themes '(sanityinc-tomorrow-night))
 '(custom-safe-themes
   '("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default))
 '(gnutls-algorithm-priority "normal:-vers-tls1.3")
 '(jabber-resource-line-format "     %r - %s")
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(org-agenda-files '("~/todo.org"))
 '(package-selected-packages
   '(key-chord dockerfile-mode bundler rubocop robe inf-ruby rspec-mode poly-markdown poly-noweb poly-R julia-mode helm projectile ws-butler uuid editorconfig zop-to-char zenburn-theme yaml-mode which-key wgrep volatile-highlights vkill twittering-mode smex smartrep smartparens smart-mode-line scss-mode rainbow-mode rainbow-delimiters polymode php-mode ox-pandoc ox-gfm ov org-ref operate-on-number mu4e-maildirs-extension move-text markdown-mode magit key-combo json-mode jabber imenu-anywhere helm-projectile helm-descbinds helm-ag guru-mode grizzl god-mode gitignore-mode gitconfig-mode git-timemachine gist geiser flycheck flx-ido floobits expand-region exec-path-from-shell ess emoji-cheat-sheet-plus elpy elisp-slime-nav ein easy-kill discover-my-major diminish diff-hl csv-mode crux company-auctex company-anaconda color-theme-sanityinc-tomorrow cdlatex browse-kill-ring beacon anzu ace-window ac-emoji))
 '(pdf-view-midnight-colors '("#DCDCCC" . "#383838")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "unknown")))))

;; Package repositories
(require 'package)

;; (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
;; (add-to-list 'package-archives '("elpy" . "https://jorgenschaefer.github.io/packages/"))
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpy" . "https://jorgenschaefer.github.io/packages/")))


(prelude-require-packages '(anzu
                            color-theme-sanityinc-tomorrow
                            ein
                            emoji-cheat-sheet-plus
                            elpy
                            ess
                            floobits
                            inf-ruby
                            jabber
                            key-combo
                            markdown-mode
                            org
                            org-ref
                            ox-gfm
                            ox-pandoc
                            polymode
                            projectile
                            pyvenv
                            rspec-mode
                            ruby-mode
                            twittering-mode
                            undo-tree
                            use-package
                            wgrep
                            ws-butler))

;; Check if computer is my work computer
(defun work-computer ()
  (interactive)
  (string-equal (system-name) "heimalandi.local"))

;; Start up in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))

;; Load flip-tables (╯°□°）╯︵ ┻━━┻  & shrug ¯\_(ツ)_/¯
(defvar load-personal-config-list)
(setq load-personal-config-list '("/flip-tables.el"
                                  "/shrug.el"))

(mapc (lambda (rmd-file-name)
        (load (concat prelude-personal-dir rmd-file-name)))
      load-personal-config-list)

;; Remap meta and super on Mac
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

;; Fill paragraphs at 80 characters
(setq-default fill-column 80)

;; Set default directory to home
(setq default-directory "~/")

;; Disable whitespace mode
(setq prelude-whitespace nil)

;; C-x C-b should bring up ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; And C-c C-b should eval-buffer wtf why did this disappear?
(global-set-key (kbd "C-c C-b") 'eval-buffer)

;; Function to swap buffer orientation
;; http://www.emacswiki.org/emacs/ToggleWindowSplit
(defun toggle-window-split ()
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

(global-set-key (kbd "C-x 5") 'toggle-window-split)

;; Insert iso-date
(defun insert-iso-date ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d" (current-time))))

;; Modifications to kill-sentence so that it doesn't delete the period when
;; point is in the middle of a sentence.
;; http://emacs.stackexchange.com/a/12321/7060
(defun my/forward-to-sentence-end ()
  "Move point to just before the end of the current sentence."
  (forward-sentence)
  (backward-char)
  (unless (looking-back "[[:alnum:]]")
    (backward-char)))

(defun my/beginning-of-sentence-p ()
  "Return  t if point is at the beginning of a sentence."
  (let ((start (point))
        (beg (save-excursion (forward-sentence) (forward-sentence -1))))
    (eq start beg)))

(defun my/kill-sentence-dwim ()
  "Kill the current sentence up to and possibly including the punctuation.
When point is at the beginning of a sentence, kill the entire
sentence. Otherwise kill forward but preserve any punctuation at the sentence end."
  (interactive)
  (if (my/beginning-of-sentence-p)
      (progn
        (kill-sentence)
        (just-one-space)
        (when (looking-back "^[[:space:]]+") (delete-horizontal-space)))
    (kill-region (point) (progn (my/forward-to-sentence-end) (point)))
    (just-one-space 0)))

(define-key (current-global-map) [remap kill-sentence] 'my/kill-sentence-dwim)

;; Function to insert new code chunk in R Markdown
;; http://emacs.stackexchange.com/a/27419/7060
(defun new-chunk (header)
  "Insert an r-chunk in markdown mode. Necessary due to interactions between polymode and yasnippet"
  (interactive "sHeader: ")
  (insert (concat "```{r " header "}\n\n```"))
  (forward-line -1))

;; My sentences have one space after a period.
(setq sentence-end-double-space nil)

;; Don't make that awful sound
(setq ring-bell-function #'ignore)

;; Turn off flycheck. Too many problems.
(global-flycheck-mode -1)

;; Turn on smartparens
(smartparens-global-mode t)

;; Timezones
(setq display-time-world-list
      '(("America/Los_Angeles" "Pacific")
        ("America/New_York" "Eastern")
        ("Asia/Irkutsk" "Irkutsk")))

;; Smoother scrolling
;; http://www.emacswiki.org/emacs/SmoothScrolling
;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Remove scroll bars
(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                ESS mode                                ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Activate ESS
(require 'ess-site)

;; Style
(setq ess-default-style 'RStudio)

(defun my-ess-settings ()
  ;; Don't move comments (comment-dwim still moves them so this only sort of
  ;; works)
  (setq ess-indent-with-fancy-comments nil)
  ;; 2 space indentation
  (setq ess-indent-offset 2))
(add-hook 'ess-mode-hook #'my-ess-settings)

;; Smartparens in R repl
(add-hook 'ess-R-post-run-hook (lambda () (smartparens-mode 1)))
(add-hook 'inferior-ess-mode-hook (lambda () (smartparens-mode 1)))

;; Disable conversion of underscores to arrows; map to M-- instead
(define-key ess-mode-map [?_] nil)
(define-key inferior-ess-mode-map [?_] nil)
(defun assign_key ()
  "I don't understand why assignment operators in ESS are so confusing, guess I'll write my own."
  (interactive)
  (just-one-space 1)
  (insert "<- "))
(define-key ess-mode-map (kbd "M--") 'assign_key)
(define-key inferior-ess-mode-map (kbd "M--") 'assign_key)

;; When wrapping long lists of function args, put the first on a new line
(setq ess-fill-calls-newlines t)

;; Don't restore history or save on exit
(setq-default inferior-R-args "--no-restore-history --no-save")

;; Don't ask me for a directory on startup
(setq ess-ask-for-ess-directory nil)

;; Turn on tab completion
(setq ess-tab-complete-in-script t)

;; Bind M-enter to ess-eval-region-or-line-visibly-and-step
(define-key ess-mode-map (kbd "M-<return>")
  'ess-eval-region-or-line-visibly-and-step)

;; Use s-return to set directory to location of current file
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(s-return)] 'ess-use-this-dir)))

;; %>% shortcut
;; http://emacs.stackexchange.com/a/8055/7060
(defun then_R_operator ()
  "R - %>% operator or 'then' pipe operator"
  (interactive)
  (just-one-space 1)
  (insert "%>%")
  (reindent-then-newline-and-indent))
(define-key ess-mode-map (kbd "C->") 'then_R_operator)
(define-key inferior-ess-mode-map (kbd "C->") 'then_R_operator)

;; Bring up empty R script and R console for quick calculations
(defun R-scratch ()
  (interactive)
  (progn
    (delete-other-windows)
    (setq new-buf (get-buffer-create "scratch.R"))
    (switch-to-buffer new-buf)
    (R-mode)
    (setq w1 (selected-window))
    (setq w1name (buffer-name))
    (setq w2 (split-window w1 nil t))
    (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
        (R))
    (set-window-buffer w2 "*R*")
    (set-window-buffer w1 w1name)))

(global-set-key (kbd "C-x 9") 'R-scratch)

(defun ess-r-shiny-run-app (&optional arg)
  "Interface for `shiny::runApp()'.
With prefix ARG ask for extra args."
  (interactive)
  (inferior-ess-r-force)
  (ess-eval-linewise
   "shiny::runApp(\".\")\n" "Running app" arg
   '("" (read-string "Arguments: " "recompile = TRUE"))))


(use-package xterm-color
             :load-path "/Users/kara/projects/forks/xterm-color/"

             :init
             (setq comint-output-filter-functions
                   (remove 'ansi-color-process-output comint-output-filter-functions))

             (add-hook 'inferior-ess-mode-hook
                       (lambda () (add-hook 'comint-preoutput-filter-functions #'xterm-color-filter nil t)))

             :config
             (setq xterm-color-use-bold t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                            Google Translate                            ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq google-translate-translation-directions-alist '(("ru" . "en") ("en" . "ru")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                  Helm                                  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Give me my damn tab completion
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                 Jabber                                 ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set up google talk
(setq jabber-account-list
      '(("woo.kara@gmail.com"
         (:network-server . "talk.google.com")
         (:connection-type . ssl)
         (:port . 443))))

;; No avatars, please
(setq jabber-avatar-verbose nil
      jabber-vcard-avatars-retrieve nil)

(setq jabber-roster-line-format " %c %n - %s")

;; Don't show status changes in minibuffer
(setq jabber-alert-presence-message-function nil)

;; Enable history
(setq jabber-history-enabled nil)

;; Shorten buffer names
(setq jabber-chat-buffer-format "*-jabber-%n-*"
      jabber-roster-buffer "*-jabber-*")

;; View emoji in jabber
(add-hook 'jabber-chat-mode-hook (lambda () (emoji-cheat-sheet-plus-display-mode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                Key-chord                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'prelude-key-chord)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                Key-combo                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-key-combo-mode t)

(defvar ess-key-combos
  '(("+"  . ("+" " + "))
    ("-"  . ("-" " - "))
    ("*"  . ("*" " * "))
    ("/"  . ("/" " / "))
    (">"  . (">" " %>% "))))

(key-combo-define-hook '(ess-mode-hook inferior-ess-mode-hook)
                       'ess-key-combo-load-default
                       ess-key-combos)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                   js                                   ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Two space indent for json
(setq js-indent-level 2)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                Markdown                                ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Don't strip trailing whitespace in markdown mode
(add-hook 'markdown-mode-hook
          (lambda ()
            (make-local-variable 'prelude-clean-whitespace-on-save)
            (setq-local prelude-clean-whitespace-on-save nil)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                  mu4e                                  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;; Thanks @gastove :D

;; ;;; Commentary:
;; ;; Borrowed, gratefully, from
;; ;; http://kirang.in/2014/11/13/emacs-as-email-client-with-offlineimap-and-mu4e-on-osx/
;; ;;; Code:

;; ;; If I want multiple accounts, need to manage these:
;; ;; (setq mu4e-sent-folder "/Account1/Saved Items" ;; check
;; ;;      mu4e-drafts-folder "/Account1/Drafts"     ;; check
;; ;;      user-mail-address "my.address@account1.tld" ;; check
;; ;;      smtpmail-default-smtp-server "smtp.account1.tld" ;; check
;; ;;      smtpmail-local-domain "account1.tld"
;; ;;      smtpmail-smtp-server "smtp.account1.tld" ;; check
;; ;;      smtpmail-stream-type starttls
;; ;;      smtpmail-smtp-service 25)

;; ;; Re-enable C-x m for email (nerfs eshell, which I never use)
;; (global-set-key (kbd "C-x m") 'compose-mail)

;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
;; (require 'mu4e)
;; (setq mu4e-maildir "~/.mail")
;; (setq mu4e-drafts-folder "/woo.kara@gmail.com/[Gmail].Drafts")
;; (setq mu4e-sent-folder   "/woo.kara@gmail.com/[Gmail].Sent Mail")
;; ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
;; (setq mu4e-sent-messages-behavior 'delete)
;; ;; allow for updating mail using 'U' in the main view:
;; (setq mu4e-get-mail-command "offlineimap")

;; ;; Make mu4e the default user agent
;; (setq mail-user-agent 'mu4e-user-agent)

;; ;; mu4e mail dirs
;; (require 'mu4e-maildirs-extension)
;; (mu4e-maildirs-extension)

;; ;; shortcuts
;; (setq mu4e-maildir-shortcuts
;;       '(("/woo.kara@gmail.com/INBOX"               . ?i)
;;         ("/woo.kara@gmail.com/[Gmail].Important"   . ?I)
;;         ("/woo.kara@gmail.com/[Gmail].Sent Mail"   . ?s)))

;; ;; something about ourselves
;; (setq user-mail-address "woo.kara@gmail.com"
;;       user-full-name  "Kara Woo")

;; ;; ISO date format
;; (setq mu4e-headers-date-format "%Y-%m-%d")

;; ;; The next two things are supposed to help show inline images in emails but
;; ;; Ross says they don't work so much
;; ;; show images
;; (setq mu4e-show-images t)

;; ;; use imagemagick, if available
;; (when (fboundp 'imagemagick-register-types)
;;   (imagemagick-register-types))

;; ;; convert html emails properly
;; ;; Possible options:
;; ;;   - html2text -utf8 -width 72
;; ;;   - textutil -stdin -format html -convert txt -stdout
;; ;;   - html2markdown | grep -v '&nbsp_place_holder;' (Requires html2text pypi)
;; ;;   - w3m -dump -cols 80 -T text/html
;; ;;   - view in browser (provided below)
;; ;; (setq mu4e-html2text-command "textutil -stdin -format html -convert txt -stdout")
;; ;; (setq mu4e-html2text-command "pandoc -f html -t plain")
;; (require 'mu4e-contrib)
;; (setq mu4e-html2text-command 'mu4e-shr2text)

;; ;; Message Composition settings: turn off auto-fill-mode
;; (add-hook 'mu4e-compose-mode-hook
;;           (lambda ()
;;             (auto-fill-mode -1)
;;             ))

;; ;; add option to view html message in a browser
;; ;; `aV` in view to activate
;; (add-to-list 'mu4e-view-actions
;;              '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; ;; fetch mail every 10 mins
;; (setq mu4e-update-interval 600)

;; ;; configuration for sending mail
;; (setq message-send-mail-function
;;       'sendmail-send-it
;;       ;; smtpmail-stream-type 'starttls
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587
;;       smtpmail-smtp-user "woo.kara"
;;       smtpmail-mail-address "woo.kara@gmail.com"
;;       mail-specify-envelope-from t
;;       mail-envelope-from 'header
;;       )

;; ;; Tweak bookmarked queries
;; (add-to-list 'mu4e-bookmarks `(,(string-join
;;                                  '("flag:unread"
;;                                    "AND m:/woo.kara@gmail.com/INBOX"
;;                                    "NOT maildir:'/woo.kara@gmail.com/github'"
;;                                    "NOT maildir:'/woo.kara@gmail.com/Brown'"
;;                                    "NOT maildir:'/woo.kara@gmail.com/Lists'"
;;                                    "AND date:today..now")
;;                                  " ") "Today's personal Unreads" ?h))
;; (add-to-list 'mu4e-bookmarks `(,(string-join
;;                                  '("flag:unread"
;;                                    "AND date:today..now"
;;                                    "NOT maildir:'/woo@nceas.ucsb.edu/Ecolog'"
;;                                    "NOT maildir:'/woo@nceas.ucsb.edu/Redmine'"
;;                                    "AND m:/woo@nceas.ucsb.edu/INBOX")
;;                                  " ")
;;                                "Today's work unreads" ?i))
;; (add-to-list 'mu4e-bookmarks `(,(string-join
;;                                  '("flag:unread"
;;                                    "AND m:/woo.kara@gmail.com/INBOX"
;;                                    "AND date:today..now"
;;                                    "OR flag:unread"
;;                                    "AND m:/woo@nceas.ucsb.edu/INBOX"
;;                                    "AND date:today..now")
;;                                  " ") "Today's Unreads" ?g))

;; ;; Switch accounts

;; (defvar my-mu4e-account-alist
;;   '(("woo.kara@gmail.com"
;;      (mu4e-drafts-folder "/woo.kara@gmail.com/[Gmail].Drafts")
;;      (mu4e-sent-folder   "/woo.kara@gmail.com/[Gmail].Sent Mail")
;;      (smtpmail-mail-address "woo.kara@gmail.com")
;;      (user-mail-address "woo.kara@gmail.com")
;;      (smtpmail-smtp-user "woo.kara"))
;;     ("woo@nceas.ucsb.edu"
;;      (mu4e-drafts-folder "/woo@nceas.ucsb.edu/[Gmail].Drafts")
;;      (mu4e-sent-folder   "/woo@nceas.ucsb.edu/[Gmail].Sent Mail")
;;      (smtpmail-mail-address "woo@nceas.ucsb.edu")
;;      (user-mail-address "woo@nceas.ucsb.edu")
;;      (smtpmail-smtp-user "woo@nceas.ucsb.edu"))))

;; (defun my-mu4e-set-account ()
;;   "Set the account for composing a message."
;;   (let* ((account
;;           (if mu4e-compose-parent-message
;;               (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
;;                 (string-match "/\\(.*?\\)/" maildir)
;;                 (match-string 1 maildir))
;;             (completing-read (format "Compose with account: (%s) "
;;                                      (mapconcat #'(lambda (var) (car var))
;;                                                 my-mu4e-account-alist "/"))
;;                              (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
;;                              nil t nil nil (caar my-mu4e-account-alist))))
;;          (account-vars (cdr (assoc account my-mu4e-account-alist))))
;;     (if account-vars
;;         (mapc #'(lambda (var)
;;                   (set (car var) (cadr var)))
;;               account-vars)
;;       (error "No email account found"))))

;; (add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

;; ;; Don't show messages in duplicate
;; (setq mu4e-headers-skip-duplicates t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                Org mode                                ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org)

;; Disable whitespace mode in org mode
(add-hook 'org-mode-hook (lambda () (whitespace-mode -1)))

;; Visual line mode
(add-hook 'org-mode-hook (lambda () (visual-line-mode 1)))

;; Disable folding on startup in org
(setq org-startup-folded nil)

;; Start indented in org
(setq org-startup-indented t)

;; Set TODO keyword options
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE" "CLOSED")))

;; Org capture headers for work
(define-key global-map "\C-cc" 'org-capture)

(if (work-computer)
    (setq org-capture-templates
          '(("g" "General TODOs" entry (file+headline "~/todo.org" "General tasks")
             "* TODO %?\n  %i")
            ("i" "Sys Bio Infrastructure" entry (file+headline "~/todo.org" "Sys Bio Infrastructure")
             "* TODO %?\n  %i")
            ("t" "TREAT-AD tasks" entry (file+headline "~/todo.org" "TREAT-AD")
             "* TODO %?\n  %i")
            ("a" "AMP-AD tasks" entry (file+headline "~/todo.org" "AMP-AD")
             "* TODO %?\n  %i")
            ("m" "Mouse Agora tasks" entry (file+headline "~/todo.org" "Magora")
             "* TODO %?\n  %i")
            ("w" "Metadata WG tasks" entry (file+headline "~/todo.org" "Schemas/metadata working group")
             "* TODO %?\n  %i"))))

;; Add smartparens options
(sp-local-pair 'org-mode "~" "~")
(sp-local-pair 'org-mode "/" "/")
(sp-local-pair 'org-mode "*" "*")

;; Allow double quote at the end of a verbatim or code segment
(setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n,")
(org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)

;; Export options
(setq org-export-backends
      `(deck
        gfm
        html
        md
        pandoc))

(require 'ox-latex)

;; Export from org using XeLaTeX
;; From http://lists.gnu.org/archive/html/emacs-orgmode/2013-05/msg00975.html
;; remove "inputenc" from default packages as it clashes with xelatex
(setf org-latex-default-packages-alist
      (remove '("AUTO" "inputenc" t) org-latex-default-packages-alist))
(add-to-list 'org-latex-packages-alist '("" "xltxtra" t))

;; org to latex customisations, -shell-escape needed for minted
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; Minted for syntax highlighting
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

;; Function to export markdown, LaTeX, and PDF simultaneously
(defun org-export-mtp ()
  (interactive)
  (org-pandoc-export-to-markdown)
  (org-latex-export-to-pdf))

;; Collapse emphasis marks in org mode
(setq org-hide-emphasis-markers t)

;; Org header for non .org files that I want to open in org mode
(defun insert-org-header ()
  (interactive)
  (save-excursion
    (goto-line 1)
    (end-of-line)
    (insert " -*- mode: org -*-")))

;; Export quotes using \enquote{}
(add-to-list 'org-export-smart-quotes-alist
             '("am"
               (opening-double-quote :utf-8 "“" :html "&ldquo;" :latex "\\enquote{" :texinfo "``")
               (closing-double-quote :utf-8 "”" :html "&rdquo;" :latex "}" :texinfo "''")
               (opening-single-quote :utf-8 "‘" :html "&lsquo;" :latex "\\enquote*{" :texinfo "`")
               (closing-single-quote :utf-8 "’" :html "&rsquo;" :latex "}" :texinfo "'")
               (apostrophe :utf-8 "’" :html "&rsquo;")))

(setq org-export-with-smart-quotes t)

(setq org-export-allow-bind-keywords t)

;; Place captions below tables
(setq org-latex-caption-above nil)

;; Additional LaTeX classes:

;; CV
(add-to-list 'org-latex-classes
             '("cv"
               "\\documentclass{cv}
               [NO-DEFAULT-PACKAGES]
               [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Add hw class to org-latex-classes
(add-to-list 'org-latex-classes
             '("hw"
               "\\documentclass{hw}
               [NO-DEFAULT-PACKAGES]
               [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; SIGCHI template
(add-to-list 'org-latex-classes
             '("sigchi"
               "\\documentclass{sigchi}
               [NO-DEFAULT-PACKAGES]
               [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; letter class
(add-to-list 'org-latex-classes
             '("letter"
               "\\documentclass{letter}
               [NO-DEFAULT-PACKAGES]
               [EXTRA]"))

;; invoice class
(add-to-list 'org-latex-classes
             '("invoice"
               "\\documentclass{invoice}
               [NO-DEFAULT-PACKAGES]
               [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                Org-babel                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (lisp . t)
   (python . t)
   (R . t)
   (shell . t)))

;; Quit asking if I want to evaluate the source blocks, I do
(setq org-confirm-babel-evaluate nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                 Org-ref                                ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set default bibliography
(setq reftex-default-bibliography '("~/references.bib"))

;; Set default bibliography for helm
(setq bibtex-completion-bibliography "~/references.bib")

;; Use citep by default (instead of cite)
;; (setq org-ref-default-citation-link "citep")

(require 'org-ref)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                Polymode                                ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; Export files with the same name as the main file
(setq polymode-exporter-output-file-format "%s")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                               Projectile                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq projectile-mode-line "Projectile")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                       Python, Elpy, Pyvenv, EIN                        ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Indentation
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq python-indent 4)))

;; Use Elpy
;; (package-initialize)
(elpy-enable)

;; Use IPython interpreter
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;; Python environments
(setenv "WORKON_HOME" "/Users/kwoo/envs")

;; Use Django-style docstrings
(setq python-fill-docstring-style 'django)

;; Imitate ess-eval-region-or-line-and-step behavior in Python
(defun py-eval-region-or-line-and-step ()
  (interactive)
  (if (and transient-mark-mode mark-active
           (> (region-end) (region-beginning)))
      (elpy-shell-send-region-or-buffer)
    (progn
      (end-of-line)
      (let ((eol (point)))
        (beginning-of-line)
        (python-shell-send-region (point) eol))
      (python-nav-forward-statement)
      )))

;; Map py-eval-region-or-line-and-step to M-ret because that's how I have it set
;; for ESS
(define-key python-mode-map (kbd "M-<return>") 'py-eval-region-or-line-and-step)

;; In EIN mode, M-return should evaluate the current cell
;; Require ein-notebook first or else I get an error
;; https://github.com/millejoh/emacs-ipython-notebook/issues/174
(require 'ein-notebook)
(define-key ein:notebook-mode-map (kbd "M-<return>") 'ein:worksheet-execute-cell-and-goto-next)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                ruby-mode                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ruby-mode)

(add-to-list 'auto-mode-alist
             '("\\.\\(?:cap\\|gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))

;; Ruby mode
(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'ruby-mode-hook 'company-mode)
(add-hook 'ruby-mode-hook 'electric-pair-mode)

(require 'rspec-mode)
(eval-after-load 'rspec-mode '(rspec-install-snippets))
(setq rspec-use-docker-when-possible t)
(setq rspec-docker-cwd "/data/")
(setq rspec-docker-container "web")

;; Bundler
(define-key ruby-mode-map (kbd "C-c TAB") 'bundle-install)
(define-key ruby-mode-map (kbd "C-c C-e") 'bundle-exec)
(define-key ruby-mode-map (kbd "C-c C-u") 'bundle-console)

;; Guard
(define-key ruby-mode-map (kbd "C-c C-g") 'ruby-guard)

(setq inf-ruby-default-implementation "pry")
(add-hook 'after-init-hook 'inf-ruby-switch-setup)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                  Tramp                                 ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq tramp-verbose 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                 Twitter                                ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq twittering-use-master-password t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                ws-butler                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Trim whitespace only on edited lines
(require 'ws-butler)
(ws-butler-global-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                Yasnippet                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(yas-global-mode t)


;;; ----------------------------------------------------------------------------

(provide 'custom)

;;; custom.el ends here
