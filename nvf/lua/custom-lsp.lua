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

-- Configure rust-analyzer to use clippy
vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
})

-- Enable custom LSP servers
vim.lsp.enable("nixd")
vim.lsp.enable("expert")
vim.lsp.enable("nextls")
vim.lsp.enable("emmet_ls")
vim.lsp.enable("lexical")
