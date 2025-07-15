(setq custom-file "~/.config/emacs/custom.el")
(load-file "~/.config/emacs/rc/rc.el")
(add-to-list 'load-path "~/.config/emacs/local")

;;(require 'tokyo-theme)
;;(load-theme 'tokyo 1 nil)
;;(rc/require-theme 'gruber-darker)
(rc/require-theme 'catppuccin)
(setq catppuccin-flavor 'macchiato)
(catppuccin-reload)

(set-face-attribute
 'default nil :slant 'normal
 :weight 'regular
 :height 144
 :width 'normal
 :foundry "CTDB"
 :family "FiraCode Nerd Font")

;; set transparency
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Disable bars
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; General config
(setq make-backup-files nil)
(setq indent-tabs-mode nil)
(setq inhibit-splash-screen t)
(setq ring-bell-function 'ignore)
(setq scroll-step 1)
(setq scroll-margin 8)
(setq display-line-numbers-type 'relative)
(setq x-select-enable-clipboard t)
(setq c-guess-guessed-basic-offset 2)
(setq c-basic-offset 2)
(setq tab-width 2)
(setq tab-always-indent nil)

;; Enable line numbers
(global-display-line-numbers-mode 1)

;; Ido mode
(ido-mode 1)
(ido-everywhere 1)

(rc/require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Major mode packages
(rc/require 'rust-mode)

;; simpc-mode
;; Importing simpc-mode
;; (require 'simpc-mode)
;; Automatically enabling simpc-mode on files with extensions like .h, .c, .cpp, .hpp
;; (add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(add-to-list 'auto-mode-alist '("\\.[hc]\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)+\\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.[hc]\\(++\\)?\\'" . c++-ts-mode))

(setq treesit-language-source-alist
      '((cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4")))

;; C autoformat
(defun astyle-buffer ()
  (interactive)
  (let ((saved-line-number (line-number-at-pos)))
    (shell-command-on-region
     (point-min)
     (point-max)
     "astyle --style=linux"
     nil
     t)
    (goto-line saved-line-number)))

;; C/C++ autocomplete
(rc/require 'company
	    'yasnippet)
(yas-global-mode 1)
(add-hook 'after-init-hook 'global-company-mode)

;; (rc/require 'irony)
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;; 
;; (rc/require 'company-irony)
;; (eval-after-load 'company
;;   '(add-to-list 'company-backends 'company-irony))

;; Misc packages
(rc/require 'mood-line
	    'magit
	    'elfeed
	    'evil)

;; elfeed config
(setq elfeed-feeds
      '(("https://archlinux.org/feeds/news/" linux)
        ("https://ctftime.org/writeups/rss/" ctf)
	("https://nedroid.com/feed/" comic)
	("https://xkcd.com/rss.xml" comic)
	("https://ladybird.org/posts.rss" linux browser)
  ("https://www.phoronix.com/rss.php" linux)
))

(setq elfeed-db-directory "~/.cache/elfeed/")

(global-set-key (kbd "C-x r") 'elfeed)
(setq browse-url-browser-function 'eww-browse-url)

(setq-default elfeed-search-filter "")

;; Entries older than 2 weeks are marked as read
;; (add-hook 'elfeed-new-entry-hook
;;           (elfeed-make-tagger :before "2 weeks ago"
;;                               :remove 'unread))

;; Mode line config
(mood-line-mode)
(setq mood-line-glyph-alist mood-line-glyphs-fira-code)

;; Evil mode config
(setq evil-want-C-u-scroll t)

;; Multiple cursors
(rc/require 'multiple-cursors)
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Open line (o/O in vim)
(defun smart-open-line ()
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun smart-open-line-above ()
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-o") 'smart-open-line)
(global-set-key (kbd "M-O") 'smart-open-line-above)

(defun toggle-noob-mode ()
  (interactive)
  (toggle-tool-bar-mode-from-frame)
  (toggle-menu-bar-mode-from-frame))

(global-set-key (kbd "M-n") 'toggle-noob-mode)

(global-unset-key (kbd "C-x m"))
(global-set-key (kbd "C-x m m") 'compile)
(global-set-key (kbd "C-x m r") 'recompile)

;; Paste with C-S-v in *terminal*
(add-hook 'term-load-hook
  (lambda () (define-key term-raw-map (kbd "C-S-v") 'term-paste)))

(load-file custom-file)
(put 'downcase-region 'disabled nil)
