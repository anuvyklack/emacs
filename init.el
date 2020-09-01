;;; init.el --- Emacs main configuration file -*- lexical-binding: t; buffer-read-only: t; no-byte-compile: t -*-
;;;
;;; Commentary:
;;; Emacs config by Yuriy Artemyev.
;;; This file was automatically generated by `org-babel-tangle'.
;;; Do not change this file.  Main config is located in .config/emacs/README.org
;;;
;;; Code:

(setq init-file (expand-file-name "init.el" user-emacs-directory)
      config-org-file (expand-file-name "README.org" user-emacs-directory))

(when window-system
  ;; (set-frame-size (selected-frame) 92 35)
  (set-frame-size (selected-frame) 145 53)
  (set-frame-position (selected-frame) 500 70)
)

;; ;; Set size parameters of ‘initial-frame-alist’ or
;; ;; ‘default-frame-alist’. E.g.,
;; (add-to-list 'default-frame-alist '(height . 24))
;; (add-to-list 'default-frame-alist '(width . 80))

;; Iosevka is my font of choice, but don't freak out if it's present.
;; (ignore-errors (set-frame-font "Iosevka-13"))
(set-frame-font "Liga Inconsolata LGC NF OT-12.0")
;; (set-frame-font "PragmataPro-10.5")

;; (setq-default frame-background-mode 'dark)
;; 
;; (setq frame-resize-pixelwise t)
;; 
;; ;; ;; Fullscreen by default, as early as possible.
;; ;; (add-to-list 'default-frame-alist '(fullscreen . maximized))
;; 
;; ;; Disable otiose GUI settings: they just waste space.
;; ;; fringe-mode is especially ruinous performance-wise.
;; (when (window-system)
;;   (tool-bar-mode -1)
;;   (menu-bar-mode -1)
;;   (scroll-bar-mode -1)
;;   (tooltip-mode -1)
;;   ;; (fringe-mode 10)  ;; Margin from the frame in pixels
;;   (fringe-mode -1)  ;; Margin from the frame in pixels
;;   (blink-cursor-mode -1)
;; )
;; 
;; ;; (global-linum-mode t)  ;; show line numbers
;; 
;; ;; (global-hl-line-mode) ;; highlight the line with cursor
;; 
;; ;; Say to Emacs that it should split frame vertically rather than
;; ;; horizontally when Emacs has the choice (eg when bringing up help).
;; (setq split-height-threshold nil)
;; ;; How many columns emacs should have in a frame to split a window
;; ;; vertically but not horizontally.
;; (setq split-width-threshold 150)
;; 
;; (add-to-list 'display-buffer-alist
;;   ;; '("*Help*" display-buffer-same-window)
;;   ;; Open *Help* buffers into vertical split on the left
;;   '("*Help"
;;    (display-buffer-reuse-window display-buffer-in-side-window)
;;    (side . left)
;;    (slot . 1)
;;    (window-width . 0.5)
;;    (reusable-frames . nil))
;; )

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(use-package better-defaults
  :straight t)

(setq-default indent-tabs-mode nil   ; no tab characters in files
              tab-width 4
              comment-empty-lines t  ; comment empty lines
              ;; При обращении к файлу уже открытому в буфере Emacs-а
              ;; по другому имени (по символической или жёсткой
              ;; ссылке), Emacs откроет уже существующий буфер, а не
              ;; создасть новый.
              find-file-existing-other-name t
              ;; delete-indentation t
)

(use-package async
  :straight t)

(use-package doom-themes
  :straight t
  :config
  ;; Global settings (defaults)
  (setq
    doom-themes-enable-bold nil  ; if nil, bold is universally disabled
    doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
  ;; (load-theme 'doom-gruvbox t)
  ;; (load-theme 'doom-material t)
  ;; (load-theme 'doom-peacoc t)
  ;; (load-theme 'doom-nova t)
)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq lisp-indent-offset 2
                  evil-shift-width lisp-indent-offset)
          )
)

(use-package evil
  :straight (:depth 1)
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-keybinding nil)
  ;; (setq evil-want-integration nil)
  :config ;; tweak evil after loading it
  (evil-mode 1)

  ;; example how to map a command in normal mode (called 'normal state' in evil)
  (define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit)
)

(use-package evil-collection
  :straight (:depth 1)
  :after evil
  ;; :straight (drag-stuff :type git :host github :repo "rejeep/drag-stuff.el"
  ;;                     :fork (:host github
  ;;                            :repo "your-name/el-patch")))
  :config
  (evil-collection-init))

(use-package evil-commentary
  :straight (:depth 1)
  :after evil
  :config
  (evil-commentary-mode)
)

(use-package evil-org
  :straight (:depth 1)
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  ;; (setq org-special-ctrl-a/e t)

  (with-eval-after-load 'evil-maps
    ;; (define-key evil-motion-state-map (kbd "SPC") nil)
    (define-key evil-motion-state-map (kbd "RET") nil)  ; отменить привязку клавиши Enter в evil-mode.
    ;; (define-key evil-motion-state-map (kbd "TAB") nil)
  )
)

(use-package evil-surround
  :straight t
  :after evil
  :config
  (global-evil-surround-mode 1))

(add-hook 'org-mode-hook
          (lambda ()
            (setq fill-column 80)  ;; set textwidth to 80

            ;; Включить автоматический пренос строк (auto fill mode).
            ;; When enabled `auto-fill-function` variable is not nil.
            ;; The same as: (auto-fill-mode 1).
            (turn-on-auto-fill)
          )
)

(use-package org
  :straight (:type built-in)
  ;; :init
  :custom
    ;; ------------------- Appearance (Внешний вид) -------------------------
    ;; Turn on ‘org-indent-mode’ on startup, which softly indent text
    ;; according to outline structure.
    (org-startup-indented t)

    ;; See also "org-indent.el" which does level-dependent indentation in a
    ;; virtual way, i.e. at display time in Emacs.
    (org-adapt-indentation nil)
    ;; WARNING: Seams it doesn't work with ‘org-startup-indented’.
    (org-odd-levels-only t)

    ;; Скрывать символы разметки такие как '*..*' чтобы отображать текст
    ;; жирным, или '~..~' для кода и т.д.
    (org-hide-emphasis-markers nil)

    (org-tags-column -75)  ;; Прижимать тэги с 75 колонке справа.

    ;; The maximum level for Imenu access to Org headlines.
    (org-imenu-depth 20)

    ;; Show inline images by default in org-mode
    (org-startup-with-inline-images t)
    (org-image-actual-width '(400))

    ;; ;; Строка, которая будет использована для обозначения свёрнугото блока
    ;; ;; текста. По умолчанию -- три точки.
    ;; (org-ellipsis "↴") ;; ↴, ▼, ▶, ⤵
    ;; ----------------------------------------------------------------------

    ;; --------------------- Source code blocks ----------------------------
    (org-src-fontify-natively t) ;; Fontify code in code blocks.

    ;; Edit src block buffer to the right of the current window, keeping all
    ;; other windows.
    (org-src-window-setup 'split-window-right)
    ;; (org-src-window-setup 'current-window)  ;; edit in current window

    ;; WARNING: It seems that this variable has been removed in current
    ;; versions of org-mode.
    ;; If non-nil, blank lines are removed when exiting the code edit buffer.
    (org-src-strip-leading-and-trailing-blank-lines t)

    ;; Put two spaces additional to indentation at the beginning
    ;; of the line in source blocks.
    (org-edit-src-content-indentation 2)
    (org-src-preserve-indentation nil)

    ;; If non-nil, the effect of TAB in a code block is as if it were
    ;; issued in the language major mode buffer.
    (org-src-tab-acts-natively t)
    ;; ----------------------------------------------------------------------

    ;; ---------------------------- Links -----------------------------------
    ;; Enter откроет сслыку при условии, что курсор находится на ней.
    ;; Follow org links by press Enter with point on it.
    (org-return-follows-link t) 

    ;; ;; Follow org links by press Tab with point on it.
    ;; (org-tab-follows-link t) 
    ;; ----------------------------------------------------------------------

  :config
  ;; Languages which can be evaluated in Org buffers.
  (org-babel-do-load-languages 'org-babel-load-languages '((python . t)
                                                           (emacs-lisp . t)
                                                           (shell . t)))
  :hook
  ;; (org-mode . prettify-symbols-mode)
  ;; (org-mode . (lambda () (setq prettify-symbols-alist
  ;;                              '(("[ ]" . "☐")
  ;;                                ("[X]" . "☑") ;; ✔
  ;;                                ("[-]" . "◿"))))) ;; ◪, ⬔
  (org-babel-after-execute . org-redisplay-inline-images)

)

(use-package org-tempo
  :straight (:type built-in)
  :after org
  :config
  ;; Type `<el Tab` to insert emacs-lisp source code block.
  ;; And type `<sh Tab` to insert bash source block.
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
)

(use-package org-superstar
  :straight t
  :hook (org-mode . org-superstar-mode)
  ;; :custom
  ;; (org-bullets-bullet-list '("⁖"))
)

(with-eval-after-load 'org
  (defvar my/show-async-tangle-results nil
    "Keep *emacs* async buffers around for later inspection.")

  (defvar my/show-async-tangle-time nil
    "Show the time spent tangling the file.")

  (defun my/config-tangle ()
    "Tangles the org file asynchronously."
    ;; (when (file-newer-than-file-p config-org-file init-file))
      (my/async-babel-tangle config-org-file))

  (defun my/async-babel-tangle (org-file)
    "Tangles the org file asynchronously."
    (let ((init-tangle-start-time (current-time))
          (file (buffer-file-name))
          (async-quiet-switch "-q"))
      (async-start
        `(lambda ()
           (require 'org)
           (org-babel-tangle-file ,org-file))
        ;; (unless *show-async-tangle-results*
        ;;   `(lambda (result)
        ;;      (if result
        ;;          (message "SUCCESS: %s successfully tangled (%.2fs)."
        ;;                   ,org-file
        ;;                   (float-time (time-subtract (current-time)
        ;;                                              ',init-tangle-start-time)))
        ;;        (message "ERROR: %s as tangle failed." ,org-file))))
      )
    )
  )
)

;; (add-to-list
;;   'safe-local-variable-values
;;   '(eval add-hook 'after-save-hook #'my/async-babel-tangle 'append 'local))

(add-hook 'after-save-hook #'my/config-tangle)

(provide 'init.el)
;;; init.el ends here
