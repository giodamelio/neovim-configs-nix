-- Treesitter configuration
-- Parsers are bundled via Nix and on rtp; this sets up highlighting/indentation
local nix = require("lib.nix")

return {
	nix.spec("nvim-treesitter", {
		lazy = false, -- Load at startup so autocmds are ready before any file opens
		config = function()
			-- Enable treesitter highlighting, indentation, and folding
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- Start the grammar, silently skip filetypes without parsers
					if not pcall(vim.treesitter.start) then
						return
					end

					-- Setup Treesitter based indenting
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					-- Setup Treesitter based folding
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
					vim.wo[0][0].foldlevel = 99 -- Start with all folds open
				end,
			})

			-- Register Hurl filetype
			vim.filetype.add({
				extension = { hurl = "hurl" },
			})
		end,
	}),
}
