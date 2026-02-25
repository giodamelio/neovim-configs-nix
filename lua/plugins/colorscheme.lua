-- Colorscheme
local nix = require("lib.nix")
return {
	nix.spec("tokyonight.nvim", {
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	}),
}
