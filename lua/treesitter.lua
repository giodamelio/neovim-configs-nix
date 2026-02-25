-- New nvim-treesitter (main branch) uses Neovim's built-in treesitter
-- Highlighting is enabled via vim.treesitter.start()

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

-- Enable Hurl
vim.filetype.add({
	extension = {
		hurl = "hurl",
	},
})
