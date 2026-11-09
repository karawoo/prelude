;;; lsp.el --- pick the LSP client before Prelude loads  -*- lexical-binding: t; -*-

;; Prelude defaults to eglot.  This has to be set in preload because
;; prelude-programming.el reads it at load time.
(setq prelude-lsp-client 'lsp-mode)
