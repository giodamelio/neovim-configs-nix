-- Custom LSP server configurations.

-- Expert LSP for Elixir
vim.lsp.config("expert", {
	cmd = { "expert", "--stdio" },
	root_markers = { "mix.exs" },
	filetypes = { "elixir", "eelixir", "heex", "surface" },
})

-- Emmet for additional filetypes
vim.lsp.config("emmet_ls", {
	filetypes = { "css", "html", "javascript", "heex", "htmldjango" },
})

-- Lexical LSP for Elixir
vim.lsp.config("lexical", {
	cmd = { "lexical" },
})

-- Note: rust-analyzer clippy is configured via vim.globals.rustaceanvim in lsp.nix
-- Enable custom LSP servers
vim.lsp.enable("nixd")
vim.lsp.enable("expert")
vim.lsp.enable("nextls")
vim.lsp.enable("emmet_ls")
vim.lsp.enable("lexical")
