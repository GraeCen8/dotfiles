;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!




;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin
      catppuccin-flavor 'mocha)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

;; lsp setup
;;
(after! lsp-mode
  (setq lsp-enable-symbol-highlighting t
        lsp-enable-on-type-formatting nil
        lsp-enable-snippet t
        lsp-headerline-breadcrumb-enable t
        lsp-modeline-diagnostics-enable t
        lsp-modeline-code-actions-enable t
        lsp-completion-provider :capf

        ;; Inlay hints
        lsp-inlay-hint-enable t

        ;; Signature help
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t
        lsp-signature-doc-lines 3))

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.2

        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t))

(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.0
        corfu-auto-prefix 1))

(after! cape
  (add-to-list 'completion-at-point-functions #'cape-file))

(after! xref
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(map! :leader
      :desc "Toggle inlay hints"
      "i h" #'lsp-inlay-hints-mode

      :prefix ("c" . "code")
      :desc "Rename"              "r" #'lsp-rename
      :desc "Code action"         "a" #'lsp-execute-code-action
      :desc "Format"              "f" #'lsp-format-buffer
      :desc "Find references"     "R" #'lsp-find-references
      :desc "Find definition"     "d" #'lsp-find-definition
      :desc "Find implementation" "i" #'lsp-find-implementation
      :desc "Find type definition" "t" #'lsp-find-type-definition
      :desc "Workspace symbols"   "s" #'consult-lsp-symbols)


(map! :leader
      "f t" #'ghostel)


;; Org setup
;;
(setq org-directory "~/org/")

(setq org-agenda-files
      (list (concat org-directory "tasks.org")
            (concat org-directory "notes.org")
            (concat org-directory "journal.org")))

(setq org-default-notes-file (concat org-directory "notes.org"))

(setq org-capture-templates
      `(
        ;; Idea capture
        ("I" "idea" entry
         (file, org-default-notes-file)
         "* %? :idea: \n%U\n")

        ;; Journal entry
        ("j" "journal" entry
         (file+olp+datetree ,(concat org-directory "journal.org"))
         "* %U\n?\n")

        ;; Note with link to source
        ("n" "note" entry
         (file ,org-default-notes-file)
         "* %? :note:\n%U\n%a\n")

        ;; Todo with context
        ("t" "task" entry
         (file+headline ,(concat org-directory "tasks.org") "Tasks")
         "* TODO %?\n%^t\n%a\n")
        ))

;; Display org popups (agenda, capture, etc.) on the right side when the
;; window is wide enough (120+ columns), otherwise at the bottom.
(defun grae/display-org-buffer (buffer alist)
  "Display org BUFFER on the right if wide, at bottom if narrow."
  (if (>= (frame-width) 120)
      (display-buffer-in-side-window buffer (append alist '((side . right) (window-width . 0.35))))
    (display-buffer-in-side-window buffer (append alist '((side . bottom) (window-height . 0.3))))))

(add-to-list 'display-buffer-alist '("\\*Org \\(Capture\\|Agenda\\|Tags\\|Note\\)\\*" . grae/display-org-buffer))
(add-to-list 'display-buffer-alist '("\\*Org Src\\*" . grae/display-org-buffer))

(setq org-agenda-window-setup 'current-window)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))
