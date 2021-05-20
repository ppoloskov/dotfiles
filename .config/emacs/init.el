;; Package -- Paul's init.el
;; Commentary:

;;; Code:
(setq user-full-name "Paul Poloskov"
      user-mail-address "ppoloskov@gmail.com")

;; Increase garbage collector limit to 124 MB
;; Warn when opening files over 10 MB
(leaf *alloc
  :setq `((gc-cons-threshold		. ,(* 124 1024 1024))
	  (large-file-warning-threshold . ,(*  10 1024 1024))
	  (read-process-output-max	. ,(*  10 1024 1024))
	  )
  )


(setq lsp-lua-diagnostics-globals ["hs" "spoon"])
(setq lsp-lua-workspace-library
      '((/Applications/Hammerspoon.app/Contents/Resources/build/stub . t)))
(setq lsp-lua-workspace-max-preload 2048)
(setq lsp-lua-workspace-preload-file-size 200)


;; Visual setting
(leaf *ui
  :custom
  ((tool-bar-mode
    blink-cursor-mode
    scroll-bar-mode) . nil)
  ((global-visual-line-mode
    global-display-line-numbers-mode
    inhibit-startup-screen) . t)
  (cursor-type . 'bar)
  (line-spacing . 0.2)
  )

(leaf *scrolling
  :custom
  (scroll-step			 . 1)
  (scroll-conservatively         . 10000)
  (mouse-wheel-scroll-amount     . '(1 ((shift) . 1)))
  (mouse-wheel-progressive-speed . nil)
  (mouse-wheel-follow-mouse	 . 't)
  )


(setq dired-listing-switches "-alh")
(setq delete-selection-mode t)
(setq sentence-end-double-space nil) ;period single space ends sentence
(setq help-window-select 'always)
;; (setq initial-major-mode 'org-mode)

;; This will push your clipboard onto the killring in case you kill
;; something in emacs before pasting the clipboard
(setq save-interprogram-paste-before-kill t)
;; pushes your current yank in emacs onto the clipboard
(setq yank-pop-change-selection t)

;; (add-to-list 'backup-directory-alist
;;              (cons "." "~/.emacs.d/backup/"))
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(expand-file-name "~/.emacs.d/backup/") t)))

;; (setq auto-save-timeout 15)
;; (setq auto-save-interval 60)

(cond
 ((find-font (font-spec :name "Hack"))
  (set-face-attribute 'default nil :height 140 :font "Hack" :weight 'regular))
 ((find-font (font-spec :name "Hack Nerd Font Mono"))
  (set-face-attribute 'default nil :height 140 :font "Hack Nerd Font Mono" :weight 'regular)))

(set-fontset-font t 'symbol (font-spec :family "Apple Symbols") nil 'prepend)
(set-fontset-font "fontset-default" 'unicode "Apple Color Emoji" nil 'prepend)

(setq initial-frame-alist '((width . 140) (height . 50)))
(setq default-frame-alist '((width . 140) (height . 50)))

(setq frame-title-format
      '((:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
       "%b"))))

(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))
    ;; Settings for Autosave and backup
    (setq
     backup-directory-alist         `(("." . ,(concat user-emacs-directory "backups")))
     auto-save-list-file-prefix      (concat user-emacs-directory "autosave/")
     auto-save-file-name-transforms `((".*" ,auto-save-list-file-prefix t))
     recentf-save-file (expand-file-name "recentf" user-emacs-directory)
     )
    ))


(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
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

;;(setq org-default-notes-file
;;      (concat org-directory "/notes.org"))

(leaf modus-themes
  :ensure t
  :config (load-theme 'modus-operandi t))

(leaf persistent-scratch
  :ensure t
  :init
  (persistent-scratch-setup-default)
  )

(leaf exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "PATH")
  (exec-path-from-shell-copy-env "SSH_AUTH_SOCK")
  )

;; (leaf icomplete-vertical
;;   :ensure t
;;   :require t
;;   :global-minor-mode savehist-mode icomplete-mode icomplete-vertical-mode
;;   :bind (:icomplete-minibuffer-map
;;          ("<down>" . icomplete-forward-completions)
;;          ("C-n" . icomplete-forward-completions)
;;          ("<up>" . icomplete-backward-completions)
;;          ("C-p" . icomplete-backward-completions)
;;          ("C-v" . icomplete-vertical-toggle))
;;   :config
;;   (setq completions-format 'one-column)
;;   (setq completions-detailed nil)
  
;;  )

(leaf visual-fill-column
  :ensure t
  ;;:hook
  ;;(visual-fill-column-mode. visual-line-mode)
  )

(leaf *org
  :hook
  (org-mode-hook .
		 (lambda ()
		   (org-indent-mode)
		   (org-num-mode)
		   ;;(visual-fill-column-mode)
		   )
		 )
  :custom
  (org-startup-indented . t)
  (org-src-tab-acts-natively . t)
  (org-num-max-level . 2)
  (org-log-into-drawer . 'LOGBOOK)
  (org-todo-keywords .
      '((sequence "TODO(t)" "|" "DONE(d!)" "NOTNEEDED(n!)")))
  :config
  (leaf ox-clip
    :ensure t
    :leaf-defer nil
    :bind (:org-mode-map
           ("s-c" . ox-clip-formatted-copy)))
  (leaf org-rich-yank
    :ensure t
    :leaf-defer nil
    :bind (:org-mode-map
           ("C-M-y" . org-rich-yank)))
  )

(leaf nov
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

(recentf-mode +1)
(show-paren-mode +1)

(leaf selectrum
 :ensure t
;;  :hook (after-init-hook . selectrum-mode)
 :init
 ;; minibuffer completion
 (selectrum-mode +1)
 ;; to save your command history on disk, so the sorting gets more
 ;; intelligent over time
 ;;(leaf selectrum-prescient :ensure t :after selectrum
 ;;  :config
 ;;  (selectrum-prescient-mode +1)
 ;;  (prescient-persist-mode +1))
 :custom
 (selectrum-refine-candidates-function    . #'orderless-filter)
 (selectrum-highlight-candidates-function . #'orderless-highlight-matches)
 )

(leaf orderless
    :ensure t
    :config
    (setq completion-styles '(partial-completion flex orderless))
    :custom
    ((read-buffer-completion-ignore-case
      read-file-name-completion-ignore-case
      enable-recursive-minibuffers
      savehist-mode) . t)
    )


(setq
 ;;   completion-styles '(orderless)
 completion-ignore-case t
 completion-category-defaults nil
 completion-category-overrides '((file (styles . (partial-completion))))
 )
 
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
  :config
  ;;(consult-preview-mode))
)
;;(use-package consult-selectrum
;;  :demand t)

;;(leaf marginalia
;;  :init
;;  (marginalia-mode))

;;(use-package ctrlf
;;  :init (ctrlf-mode 1))


(leaf company
  :ensure t
  :hook (prog-mode-hook . company-mode)
  :custom
  (company-minimum-prefix-length . 1)
  (company-idle-delay . 0.0)
  )


(leaf ispell
  ;;:if (executable-find "hunspell")
  :ensure t
  :require t
  :init
  (setenv "LANG" "en_US.UTF-8")
  (setq ispell-really-aspell nil)
  (setq ispell-really-hunspell t)
  (setq ispell-dictionary "ru_RU,en_US")
  :config
  (setq ispell-program-name "/usr/local/bin/hunspell")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "ru_RU,en_US"))

;; (leaf *ispell
;;   :require ispell
;;   :init
;;   (ispell-set-spellchecker-params)
;; ;;   ;;:init
;; ;;   ;; ;; Set $DICPATH to "$HOME/Library/Spelling" for hunspell.
;; ;;   ;; (setenv "DICPATH" (concat (getenv "HOME") "/Library/Spelling"))
;; ;;   ;; ;; Install dictionaries from 'https://github.com/wooorm/dictionaries'    
;;   :custom

(leaf flycheck
  :ensure t
  :config
  (global-flycheck-mode)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(cursor-type 'bar)
 '(global-display-line-numbers-mode t)
 '(global-visual-line-mode t)
 '(inhibit-startup-screen t)
 '(line-spacing 0.2)
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount '(1 ((shift) . 1)))
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("org" . "https://orgmode.org/elpa/")))
 '(package-selected-packages
   '('exec-path-from-shell dockerfile-mode exec-path-from-shell persistent-scratch yaml-mode which-key wcheck-mode visual-fill-column vertico spell-fu shrface selectrum-prescient ox-clip org-rich-yank orderless nov modus-themes marginalia lua-mode lsp-mode leaf-keywords icomplete-vertical guess-language flycheck consult company))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 10000)
 '(scroll-step 1)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)
