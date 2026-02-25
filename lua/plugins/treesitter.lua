-- Treesitter configuration (nvim-treesitter main branch)
-- Uses Neovim's built-in treesitter, highlighting via vim.treesitter.start()
local nix = require("lib.nix")

return {
	nix.spec("nvim-treesitter", {
		event = "BufReadPost",
		config = function()
			-- Enable treesitter highlighting for all filetypes with available parsers
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					-- Try to start treesitter highlighting, silently fail if no parser
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			-- Enable treesitter-based indentation
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- Set indent expression to treesitter
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- Enable Hurl filetype
			vim.filetype.add({
				extension = {
					hurl = "hurl",
				},
			})
		end,
	}),
}
