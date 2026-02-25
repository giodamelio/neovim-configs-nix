-- Session management
local nix = require("lib.nix")
return {
	nix.spec("persisted.nvim", {
		lazy = false,
		priority = 100,
		opts = {
			autoload = true,
		},
	}),
}
