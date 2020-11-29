;; Cleanup UI
(setq inhibit-startup-message t)
(scroll-bar-mode -1)  ; Disable visible scrollbar
(tool-bar-mode -1)    ; Disable visible tool bar
(tooltip-mode -1)     ; Disable tooltips
(set-fringe-mode 10)  ; give some breathing room
(menu-bar-mode -1)    ; Disable menu bar
(setq visible-bell t) ; No beeps

;; disable Line wrapping in programming modes
(add-hook 'prog-mode-hook (lambda () (setq truncate-lines t)))


;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "Monoid NF:antialias=subpixel" :height 130)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background nil :foreground nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "ADBO" :family "Monoid NF")))))

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("stable" . "https://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Nord Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-palenight t)
  (doom-themes-visual-bell-config))

(use-package command-log-mode)
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1))

(use-package doom-modeline
  :ensure t
  :custom ((doom-modeline-height 15))
  :init (doom-modeline-mode 1))

;; Different colors for each nested delimiter pair
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
;; Displays a nice panel for keybindings after a short delay
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; Show more info in ivy buffers
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Improved help
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package all-the-icons)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; Key bindings

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer monty/leaders
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "M-SPC")

  (monty/leaders
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(defun rune/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  term-mode
		  shell-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; use visual line motions even outside of visual-line-mode-buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; (use-package hydra)

;; (defhydra hydra-text-scale (:timeout 4)
;;   "scale text"
;;  ("j" text-scale-increase "in")
;;  ("k" text-scale-decrease "out")
;;  ("f" nil "finished" :exit t))

(monty/leaders
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode 1)
  (add-to-list 'projectile-globally-ignored-directories "Dropbox")
  (add-to-list 'projectile-globally-ignored-directories "Dokumente")
  :custom
  ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/src")
    (setq projectile-project-search-path '("~/src")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode 1))

;; Git support
(use-package magit)

(use-package evil-magit
  :after magit)

(use-package sonic-pi
  :hook (sonic-pi-mode . lsp-deferred)
  :config
  (setq sonic-pi-path "/opt/sonic-pi"))

;; Snippets

(use-package yasnippet
  :config
  (setq yas-snippet-dirs
	'("~/.emacs.d/snippets" ;; personal snippets
	  ))
  (yas-global-mode 1))

(use-package doom-snippets
  :load-path "~/.emacs.d/doom-snippets"
  :after yasnippet)

;; Org mode

(defun monty/org-mode-setup ()
  (org-indent-mode)     ;; automatically indent content under a header
  (visual-line-mode 1)
  (variable-pitch-mode 1))

(defun monty/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Different sizes for headings
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Set the default face to Monoid
  (set-face-attribute 'default nil :font "Monoid NF" :height 125)

  ;; Set the fixed pitch face to Monoid
  (set-face-attribute 'fixed-pitch nil :font "Monoid NF" :height 125)

  ;; Set the variable pitch face to Cantarell
  (set-face-attribute 'variable-pitch nil :font "Cantarell" :height 160 :weight 'regular)

  ;; Ensure that anything that should be fixed-pitch appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . monty/org-mode-setup)
  :config
  (monty/org-font-setup)
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((emacs-lisp . t)))
  :custom
  (org-ellipsis " ▾")                ;; Replace ... on closed headings
  (org-hide-emphasis-markers t)      ;; hide markers for formatting
  (org-agenda-start-with-log-mode t)
  (org-log-done 'time)               ;; log time, if a task was set to done
  (org-log-into-drawer t)
  (org-confirm-babel-evaluate nil))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

;; replace * on headings with nicer bullet points
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Code completion
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  ("C-SPC" . company-complete)
  (:map company-active-map
	("<tab>" . company-complete-selection))
  (:map lsp-mode-map
    	("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode))

(defun pagansoft/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :hook ((ruby-mode . lsp-deferred)
	 (lsp-mode . pagansoft/lsp-mode-setup))
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

;; Register solargraph LSP also for SonicPi mode
(require 'lsp-mode)
(require 'lsp-solargraph)
(add-to-list 'lsp-language-id-configuration '(sonic-pi-mode . "ruby"))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection
		   #'lsp-solargraph--build-command)
  :major-modes '(ruby-mode enh-ruby-mode sonic-pi-mode)
  :priority -1
  :multi-root lsp-solargraph-multi-root
  :library-folders-fn (lambda (_workspace) lsp-solargraph-library-directories)
  :server-id 'ruby-ls
  :initialized-fn (lambda (workspace)
		    (with-lsp-workspace workspace
					(lsp--set-configuration
					 (lsp-configuration-section "solargraph"))))))


(use-package gnu-elpa-keyring-update)


;; Easy navigation in buffer
(use-package ace-jump-mode
  :bind ((:map evil-normal-state-map
	       ("SPC" . ace-jump-mode)
	       ("M-SPC" . ace-jump-line-mode))))

(use-package company-dict
  :config
  (add-to-list 'company-backends 'company-dict))

;; TypeScript

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package ng2-mode
  :hook (ng2-mode . lsp-deferred))

(use-package evil-nerd-commenter
  :bind ("M-#" . evilnc-comment-or-uncomment-lines))
