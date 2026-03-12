-- Full variant extras for LSP.
vim.lsp.config("hls", { filetypes = { "haskell", "lhaskell", "cabal" } })
vim.lsp.enable("sourcekit")
vim.lsp.enable("unison")
vim.lsp.enable("hls")
