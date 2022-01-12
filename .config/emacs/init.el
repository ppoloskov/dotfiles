;; Package -- Summary
;;; Commentary:
;;; Paul's init.el

;;; Code:
(setq user-full-name "Paul Poloskov"
      user-mail-address "ppoloskov@gmail.com")

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  ;; add load path
  (add-to-list 'load-path (concat user-emacs-directory "elisp"))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf eshell)
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; Increase garbage collector limit to 124 MB
;; Warn when opening files over 10 MB
(leaf *alloc
  :setq `((gc-cons-threshold		. ,(* 124 1024 1024))
	  (large-file-warning-threshold . ,(*  10 1024 1024))
	  (read-process-output-max	. ,(*  10 1024 1024))
	  )
  )

;; Visual setting
(leaf *ui
  :custom
  (tool-bar-mode		.	nil)
  (blink-cursor-mode		.	nil)
  (scroll-bar-mode		.	nil)
  (global-visual-line-mode	.	t)
  (inhibit-startup-screen	.	t)
  (cursor-type			.	'bar)
  (line-spacing			.	0.15)
  (initial-frame-alist		.	'((width . 140) (height . 50)))
  (default-frame-alist		.	initial-frame-alist)
  (column-number-mode           .	t)
  (inhibit-startup-message	.	t)
  (inhibit-startup-screen       .	t)
  (help-window-select           .	t)
  )

(leaf *scrolling
  :custom
  (scroll-step			 . 1)
  (scroll-conservatively         . 10000)
  (mouse-wheel-scroll-amount     . '(1 ((shift) . 1)))
  (mouse-wheel-progressive-speed . nil)
  (mouse-wheel-follow-mouse	 . 't)
  (frame-resize-pixelwise       .	t)
  )

;; Don't want to type "yes" or "no" at prompts.
(defalias 'yes-or-no-p 'y-or-n-p)  
;; Remove custom set variables from main config file
(setq custom-file (expand-file-name
		   "emacs-custom.el" user-emacs-directory))

;; (setq dired-listing-switches "-alh")
;; (setq delete-selection-mode t)
;; (setq sentence-end-double-space nil) ;period single space ends sentence
;; (setq help-window-select 'always)

(leaf *backup
  :custom
  `(auto-save-list-file-prefix		.	,(locate-user-emacs-file "autosave/"))
  (auto-save-file-name-transforms	.	`((".*" ,auto-save-list-file-prefix t)))
  (backup-directory-alist		.	`(("." . ,(locate-user-emacs-file "backups"))))
;; (setq auto-save-timeout 15)
;; (setq auto-save-interval 60)
  )

;; ;; This will push your clipboard onto the killring in case you kill
;; ;; something in emacs before pasting the clipboard
;; (setq save-interprogram-paste-before-kill t)
;; ;; pushes your current yank in emacs onto the clipboard
;; (setq yank-pop-change-selection t)

(cond ((find-font (font-spec :name "Hack"))
       (set-face-attribute 'default nil
			   :height 140
			   :font "Hack"
			   :weight 'regular))
      ((find-font (font-spec :name "Hack Nerd Font Mono"))
       (set-face-attribute 'default nil
			   :height 140
			   :font "Hack Nerd Font Mono"
			   :weight 'regular)))

(set-fontset-font t 'symbol (font-spec :family "Apple Symbols") nil 'prepend)
(set-fontset-font "fontset-default" 'unicode "Apple Color Emoji" nil 'prepend)


;; (setq frame-title-format
;;       '((:eval (if (buffer-file-name)
;;        (abbreviate-file-name (buffer-file-name))
;;        "%b"))))

;; (eval-and-compile
;;   (when (or load-file-name byte-compile-current-file)
;;     (setq user-emacs-directory
;;      (expand-file-name
;;            (file-name-directory (or load-file-name byte-compile-current-file))))))

;;(setq org-default-notes-file
;;      (concat org-directory "/notes.org"))
(leaf modus-themes
  :ensure t
  :custom
  (modus-themes-slanted-constructs . t)
  (modus-themes-subtle-line-numbers . nil)
  (modus-themes-fringes . 'subtle)
  (modus-themes-operandi-color-overrides . '((bg-main . "#fbf8ef")))
  :config
  (load-theme 'modus-operandi t)
;;  (modus-themes-load-operandi)
  )

(leaf exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "PATH")
  (exec-path-from-shell-copy-env "SSH_AUTH_SOCK"))

;; (leaf visual-fill-column
;;   :ensure t
;;   ;;:hook
;;   ;;(visual-fill-column-mode. visual-line-mode)
;;   )
(leaf expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(leaf caddyfile-mode
  :ensure t
  :mode "Caddyfile\\'" "caddy\\.conf\\'"
  :hook (caddyfile-mode-hook .
			     (lambda ()
			       (setq-local tab-width 4)  ;; Default: 8
			       (setq-local indent-tabs-mode nil))  ;; Default: t
			     ))

(leaf org
  :ensure t
  ;;   :hook
;;   (org-mode-hook .
;; 		 (lambda ()
;; 		   (org-indent-mode)
;; 		   (org-num-mode)
;; 		   (setq create-lockfiles nil)
;; 		   ;;(visual-fill-column-mode)
;; 		   ))
  
  :custom
  (org-startup-indented . t)
  (org-src-tab-acts-natively . t)
  (org-num-max-level . 2)
  (org-log-into-drawer . 'LOGBOOK)
  (org-todo-keywords .
		     '((sequence "TODO(t)" "|" "DONE(d!)" "NOTNEEDED(n!)")))
  
  (org-src-lang-modes '(("bash"         . sh)
                        ("elisp"        . emacs-lisp)
                        ("python"       . python)
                        ("shell"        . sh)
                        ("html"         . browser)
                        ("applescript"  . applescript)
                        ("mysql"        . sql)))
  :config
  (leaf ob-browser :ensure t :require t)
  (leaf ob-http :ensure t :require t)
  
;;   (leaf ox-clip
;;     :ensure t
;;     :leaf-defer nil
;;     :bind (:org-mode-map
;;            ("s-c" . ox-clip-formatted-copy)))
;;   (leaf org-rich-yank
;;     :ensure t
;;     :leaf-defer nil
;;     :bind (:org-mode-map
;;            ("C-M-y" . org-rich-yank)))
;;   (leaf org-download
;;     :hook
;;     (org-mode-hook . org-download-enable)
;;     (dired-mode-hook  . org-download-enable)
;;     :config
;;     (setq-default org-download-image-dir "~/org/pictures/"))
  
;;   (leaf good-scroll
;;     :ensure t
;;     :hook (org-mode-hook . good-scroll-mode))

  (org-babel-do-load-languages 'org-babel-load-languages
			       '(
				 (python          . t)
				 (awk             . t)
				 (dot             . t)
				 (emacs-lisp      . t)
				 (eshell          . t)
				 (gnuplot         . t)
				 (shell           . t)
				 ;;                              '(http            . t)
				 ;;                              '(sql             . t)
				 ;;                              '(applescript     . t) ;; not apples
				 )
			       )
  )

(leaf nov
  :ensure t
  :mode "\\.epub\\'"
  :hook
  (nov-mode-hook . (lambda ()
	   (display-line-numbers-mode -1)
	   (visual-line-mode)
	   (visual-fill-column-mode)
	   (setq visual-fill-column-center-text t))
		 )
  :custom
  (nov-text-width . t)
  )

(leaf which-key
  :ensure t
  :require t
  :config
  (which-key-mode)
  )

;; Keep history between sessions
(leaf *savehist
  :custom
  (savehist-additional-variables	.
					'(kill-ring
					  search-ring
					  regexp-search-ring
					  mark-ring
					  global-mark-ring
					  extended-command-history
					  eww-history))
  (history-delete-duplicates		.	t)
  (history-length			.	10000)
  (recentf-max-saved-items		.	100) ;; just 20 is too recent
  (save-place-forget-unreadable-files . t)
  (auto-save-default              . t)
  :global-minor-mode
  (recentf-mode)
  (savehist-mode)
  (save-place-mode)
  )

 (leaf *minibuffer
   :config
   ;; I've tried to use fido-mode. Turns out it's incompartible with consult-buffer and probably others
   ;; (leaf *fido
   ;;   :disabled
   ;;   :global-minor-mode
   ;;   (fido-vertical-mode . t)
   ;;   (fido-mode . t)
   ;;   )
   (leaf marginalia
     :ensure t
     :global-minor-mode
     (marginalia-mode))

   (leaf orderless
     :ensure t
     :custom
     (completion-styles                          .
						 '(basic
						   substring
						   initials
						   flex
						   partial-completion
						   orderless))
     (completion-category-overrides              .
						 '((file (styles . (
								    flex
								    partial-completion
								    orderless)))))
     ;;    (completion-styles . '(orderless partial-completion flex))
     ;;(completion-category-overrides              .
     ;;					 '((file (styles . (partial-completion)))))
     (read-buffer-completion-ignore-case		.	t)
     (read-file-name-completion-ignore-case	.	t)
     (enable-recursive-minibuffers		.	t)
     :setq
     (completion-ignore-case . t)
     (completion-category-defaults . nil))
   
   (leaf consult
     :ensure t
     :bind (("C-c h" . consult-history)
	    ("C-c o" . consult-outline)
	    ("C-x b" . consult-buffer)
	    ("C-x 4 b" . consult-buffer-other-window)
	    ("C-x 5 b" . consult-buffer-other-frame)
	    ("C-x r x" . consult-register)
	    ("C-x r b" . consult-bookmark)
	    ("M-s o" . consult-outline)
	    ("M-s m" . consult-mark)
	    ("M-s l" . consult-line)
	    ("M-s i" . consult-imenu)
	    ("M-s e" . consult-error)
	    ("M-s m" . consult-multi-occur)
	    ("M-y" . consult-yank-pop)
	    ("<help> a" . consult-apropos))
     :init
     (fset 'multi-occur #'consult-multi-occur)
     :setq
     (completion-in-region-function . #'consult-completion-in-region)
     (consult-preview-mode))

 (leaf vertico
   :ensure t
   :init
   (setq vertico-resize nil)
   (setq vertico-cycle nil)
   :global-minor-mode
   (vertico-mode))
  )

;; ----------------------------------------

;; ;;(use-package ctrlf
;; ;;  :init (ctrlf-mode 1))

;; (leaf vue-mode
;;   :ensure t
;;   :hook
;;   ;; https://github.com/AdamNiederer/vue-mode/issues/74#issuecomment-577338222
;;   (vue-mode-hook . (lambda () (setq syntax-ppss-table nil))))

;;(add-

(leaf *programming-mode
  :config
  (leaf *line-numbers
    :hook
    (prog-mode-hook . display-line-numbers-mode))
  
  (leaf corfu
    :ensure t
    :require t
    :hook (prog-mode-hook . corfu-mode))
  
  (leaf *parens-mode
    :doc "Highlight matching parents"
    :hook (prog-mode-hook .   show-paren-mode)
    :custom
    (show-paren-when-point-inside-paren . t)
    (show-paren-when-point-in-periphery . t)
    :custom-face
    (show-paren-match . '((t (:background nil :foreground "deep pink" :weight extra-bold))))
    :config
    (print "parents!")
    )
  
  (leaf highlight-indent-guides
    :ensure t
    :hook (prog-mode-hook . highlight-indent-guides-mode)
    :custom
    (highlight-indent-guides-method . 'bitmap)
    (highlight-indent-guides-bitmap-function . 'highlight-indent-guides--bitmap-dots)
    (highlight-indent-guides-responsive . 'stack)
    (highlight-indent-guides-delay . 0))

  (leaf rainbow-delimiters
    :ensure t
    :hook (prog-mode-hook . rainbow-delimiters-mode)))

;; (leaf lua-mode
;;   :ensure t
;;   :custom
;;   (lsp-lua-diagnostics-globals . ["hs" "spoon"])
;;   (lsp-lua-workspace-library .
;; 			     '((/Applications/Hammerspoon.app/Contents/Resources/build/stub . t)))
;;   :setq
;;   (lsp-lua-workspace-max-preload . 2048)
;;   (lsp-lua-workspace-preload-file-size . 200)
;; )

(leaf yaml-mode
  :ensure t
  :mode (("\\.ya?ml$" . yaml-mode))
  )

(leaf move-text
  :ensure t
  :init
  (move-text-default-bindings))

(leaf ispell
  :ensure t
  :require t
  :custom
  (ispell-program-name . "hunspell")
  (ispell-dictionary . "ru_RU,en_AU")
  (flyspell-prog-text-faces . '(font-lock-comment-face font-lock-doc-face))
  :config
;;  (setenv "LANG" "en_AU.UTF-8")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "ru_RU,en_AU")
;;  (ispell-change-dictionary "ru_RU,en_AU" t)
;;  (flyspell-mode 1)
  )

;; ;; tts  провка 
;; ;; провка коровка провка ntgb тест \етс. turmoil. провка.  turmoil  
;; ;; Tets. 
;; ;;(leaf ispell
;; ;;   ;;:if (executable-find "hunspell")
;; ;;   :ensure t
;; ;;   :require t
;; ;;   :init
;; ;;   ;; ispell-set-spellchecker-params has to be called
;; ;;   ;; before ispell-hunspell-add-multi-dic will work
;; ;;   (ispell-set-spellchecker-params)
;; ;;   (ispell-hunspell-add-multi-dic "ru_RU,en_US"))

;; ;; (leaf *ispell
;; ;;   :require ispell
;; ;;   :init
;; ;;   (ispell-set-spellchecker-params)
;; ;; ;;   :init
;; ;; ;;    ;; Set $DICPATH to "$HOME/Library/Spelling" for hunspell.
;; ;; ;;    (setenv "DICPATH" (concat (getenv "HOME") "/Library/Spelling"))
;; ;; ;;   ;; Install dictionaries from 'https://github.com/wooorm/dictionaries'
;; ;;   :custom

;; (leaf flycheck
;;   :ensure t
;;   :config
;;   (global-flycheck-mode)
;;   )

;; Restore scratch buffer /after/ emacs init is complete, so it will call prog-mode hook
(leaf persistent-scratch
  :ensure t
  :require t
  :custom
  (persistent-scratch-autosave-mode . t)
  :hook
  (after-init-hook . persistent-scratch-restore))

(leaf *desktop
  :custom
  (desktop-load-locked-desktop . t)
  (desktop-save-mode . t)
  (desktop-save . t)
  (desktop-restore-frames . t)
  :hook
  ;; Restore desktop once everything else is loaded
  (after-init-hook . desktop-read))

;; ;;; init.el ends here

