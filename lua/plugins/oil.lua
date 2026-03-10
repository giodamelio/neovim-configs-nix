-- Oil file explorer
local nix = require("lib.nix")

return {
	nix.spec("oil.nvim", {
		lazy = false,
		opts = {
			columns = { "icon", "permissions", "size" },
		},
	}),
}
