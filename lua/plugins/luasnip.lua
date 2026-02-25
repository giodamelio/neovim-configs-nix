-- Snippets
local nix = require("lib.nix")

return {
	nix.spec("friendly-snippets", {
		lazy = true,
	}),
	nix.spec("luasnip", {
		event = "InsertEnter",
		dependencies = { "friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	}),
}
