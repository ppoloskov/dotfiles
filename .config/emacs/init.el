;;; Package -- Paul's init.el
;;; Commentary:

;;; Code:
(setq user-full-name "Paul Poloskov"
      user-mail-address "ppoloskov@gmail.com")

;; Increase garbage collector limit to 124 MB
;; Warn when opening files over 10 MB
(setq gc-cons-threshold
      (* 124 1024 1024))
(setq large-file-warning-threshold
      (* 10 1024 1024))
(setq read-process-output-max
      (* 10 1024 1024))

;; Visual setting
(tool-bar-mode -1)
(blink-cursor-mode -1)
(global-visual-line-mode 1)
(global-display-line-numbers-mode 1)
(setq-default cursor-type 'bar)
(setq-default line-spacing 0.2)
(set-face-attribute 'default nil :height 140 :font "Hack" :weight 'regular)


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

(leaf modus-operandi-theme
  :ensure t
  :config (load-theme 'modus-operandi t))

(leaf icomplete-vertical
  :ensure t
  :bind (:icomplete-minibuffer-map
         ("<down>" . icomplete-forward-completions)
         ("C-n" . icomplete-forward-completions)
         ("<up>" . icomplete-backward-completions)
         ("C-p" . icomplete-backward-completions)
         ("C-v" . icomplete-vertical-toggle))
  :config
  (setq completions-format 'one-column)
  (setq completions-detailed nil)
  (savehist-mode +1)
  (icomplete-mode +1)
  (icomplete-vertical-mode +1)
  (leaf orderless
    :ensure t
    :config
    (setq completion-styles '(partial-completion flex orderless))
    )
  )

(leaf which-key
  :ensure t
  :config
  which-key-mode
  )

(recentf-mode +1)
(show-paren-mode +1)

;; (leaf selectrum
;;   :ensure t
;;   :hook (after-init-hook . selectrum-mode)
;;   :config
;;   ;; minibuffer completion
;;   ;; (selectrum-mode +1)
;;   ;; to save your command history on disk, so the sorting gets more
;;   ;; intelligent over time
;;   (leaf selectrum-prescient :ensure t :after selectrum
;;     :config
;;     (selectrum-prescient-mode +1)
;;     (prescient-persist-mode +1))
;;   ;; (setq selectrum-refine-candidates-function #'orderless-filter)
;;   ;; (setq selectrum-highlight-candidates-function #'orderless-highlight-matches)
;;   )

(leaf flycheck
  :ensure t
  :config
  (global-flycheck-mode)

  )

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("org" . "https://orgmode.org/elpa/")))
 '(package-selected-packages
   '(which-key marginalia icomplete-vertical selectrum-prescient company yaml-mode lua-mode ox-clip org-rich-yank nov flycheck selectrum orderless modus-operandi-theme leaf-keywords)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
